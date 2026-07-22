/**
 * Tests for the visual companion's offline Superpowers Lite branding.
 */

const { spawn } = require('child_process');
const http = require('http');
const fs = require('fs');
const path = require('path');
const assert = require('assert');

const REPO_ROOT = path.join(__dirname, '../..');
const SERVER_PATH = path.join(REPO_ROOT, 'skills/brainstorming/scripts/server.cjs');
const PACKAGE_VERSION = JSON.parse(
  fs.readFileSync(path.join(REPO_ROOT, 'package.json'), 'utf-8')
).version;
const TOKEN = 'testtoken-branding-0123456789abcdef';
const PROJECT_URL = 'https://github.com/nanyumeng/superpowers-lite';

function cleanup(dir) {
  if (fs.existsSync(dir)) {
    fs.rmSync(dir, { recursive: true });
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function startServer({ port, dir, env = {}, serverPath = SERVER_PATH }) {
  cleanup(dir);
  return spawn('node', [serverPath], {
    env: {
      ...process.env,
      BRAINSTORM_PORT: String(port),
      BRAINSTORM_DIR: dir,
      BRAINSTORM_TOKEN: TOKEN,
      ...env
    }
  });
}

function waitForServer(server) {
  let stdout = '';
  let stderr = '';

  return new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error(`Server did not start. stderr: ${stderr}`)), 5000);
    server.stdout.on('data', (data) => {
      stdout += data.toString();
      if (stdout.includes('server-started')) {
        clearTimeout(timeout);
        resolve();
      }
    });
    server.stderr.on('data', (data) => { stderr += data.toString(); });
    server.on('error', reject);
  });
}

function fetchHtml(port) {
  return new Promise((resolve, reject) => {
    const headers = { Cookie: `brainstorm-key-${port}=${TOKEN}` };
    http.get(`http://localhost:${port}/`, { headers }, (res) => {
      let body = '';
      res.on('data', chunk => { body += chunk; });
      res.on('end', () => resolve(body));
    }).on('error', reject);
  });
}

function writeFragment(dir) {
  const contentDir = path.join(dir, 'content');
  fs.mkdirSync(contentDir, { recursive: true });
  fs.writeFileSync(path.join(contentDir, 'screen.html'), '<h2>Pick a layout</h2>');
}

function createPackagedServerFixture(version) {
  const root = fs.mkdtempSync(path.join('/tmp', 'superpowers-packaged-server-'));
  const scriptDir = path.join(root, 'skills/brainstorming/scripts');
  fs.cpSync(path.join(REPO_ROOT, 'skills/brainstorming/scripts'), scriptDir, { recursive: true });
  fs.mkdirSync(path.join(root, '.codex-plugin'), { recursive: true });
  fs.writeFileSync(
    path.join(root, '.codex-plugin/plugin.json'),
    JSON.stringify({ name: 'superpowers', version }, null, 2)
  );
  return {
    root,
    serverPath: path.join(scriptDir, 'server.cjs')
  };
}

async function withServer(options, fn) {
  const server = startServer(options);
  try {
    await waitForServer(server);
    await fn();
  } finally {
    if (server.exitCode === null && server.signalCode === null) {
      server.kill();
      await new Promise(resolve => server.once('exit', resolve));
    }
    await sleep(100);
    cleanup(options.dir);
  }
}

let passed = 0;
let failed = 0;

async function test(name, fn) {
  try {
    await fn();
    console.log(`  PASS: ${name}`);
    passed++;
  } catch (e) {
    console.log(`  FAIL: ${name}`);
    console.log(`    ${e.message}`);
    failed++;
  }
}

function assertLiteBranding(html, version = PACKAGE_VERSION) {
  assert(
    html.includes(`Superpowers Lite v${version}`),
    'branding text should include dynamic package version'
  );
  assert(
    html.includes(`<a href="${PROJECT_URL}">`),
    'branding should link to the Superpowers Lite repository'
  );
  assert(
    !html.includes('primeradiant.com') && !html.includes('Prime Radiant'),
    'branding must not contain inherited upstream brand or telemetry endpoints'
  );
  assert(
    !/<img\b[^>]*src=["']https?:\/\//i.test(html),
    'branding must not load a remote image'
  );
  assert(
    /\.brand a\s*\{[^}]*line-height:\s*1/i.test(html),
    'brand row should use a compact line height'
  );
  assert(
    /\.brand a\s*\{[^}]*max-width:\s*100%/i.test(html),
    'brand link should be constrained so it cannot overlap the status column'
  );
  assert(
    /\.brand\s*\{[^}]*line-height:\s*1/i.test(html),
    'brand wrapper should not inherit the page line height'
  );
  assert(
    /\.brand\s*\{[^}]*overflow:\s*hidden/i.test(html),
    'brand wrapper should clip before it reaches the status column'
  );
  assert(!html.includes('class="brand-logo"'), 'branding should not render a logo image');
  assert(
    /\.brand-copy\s*\{[^}]*line-height:\s*1/i.test(html),
    'version text should use a compact line height'
  );
  assert(
    /\.brand-copy\s*\{[^}]*min-width:\s*0/i.test(html),
    'version text should be allowed to shrink inside the brand row'
  );
}

function assertFramedScreenUsesBrandHeader(html) {
  assert(!html.includes('<div class="indicator-bar">'), 'framed screens should not render footer chrome');
  assert(
    /<div class="header">[\s\S]*<div class="brand">[\s\S]*<div class="status">Connecting…<\/div>/.test(html),
    'header should contain branding and connection status'
  );
  assert(!html.includes('id="indicator-text"'), 'header should not render the selection indicator text');
  assert(!html.includes('Click an option above'), 'header should not render the selection instruction');
}

function assertHeaderAvoidsNarrowOverlap(html) {
  assert(
    /grid-template-columns:\s*minmax\(0,\s*1fr\)\s*auto/i.test(html),
    'header should allocate shrinkable space to branding before the status column'
  );
  assert(
    /\.header \.status\s*\{[^}]*grid-column:\s*2/i.test(html),
    'status should live in the final fixed-width grid column'
  );
  assert(
    /\.header \.brand\s*\{[^}]*width:\s*100%/i.test(html),
    'header brand should fill its grid track so overflow clipping prevents overlap'
  );
}

async function main() {
  console.log('\n--- Visual Companion Branding ---');

  await test('framed screens render offline Superpowers Lite branding', async () => {
    const port = 3451;
    const dir = '/tmp/brainstorm-branding-default';
    await withServer({ port, dir }, async () => {
      writeFragment(dir);
      await sleep(300);
      const html = await fetchHtml(port);
      assertLiteBranding(html);
      assertFramedScreenUsesBrandHeader(html);
      assertHeaderAvoidsNarrowOverlap(html);
    });
  });

  await test('waiting screen renders offline Superpowers Lite branding', async () => {
    const port = 3452;
    const dir = '/tmp/brainstorm-branding-waiting';
    await withServer({ port, dir }, async () => {
      const html = await fetchHtml(port);
      assert(html.includes('Waiting for the agent'), 'waiting page should still render');
      assertLiteBranding(html);
    });
  });

  await test('packaged Codex plugin reads version from .codex-plugin manifest', async () => {
    const port = 3457;
    const dir = '/tmp/brainstorm-branding-packaged-codex';
    const packagedVersion = '7.8.9';
    const fixture = createPackagedServerFixture(packagedVersion);

    try {
      await withServer({ port, dir, serverPath: fixture.serverPath }, async () => {
        writeFragment(dir);
        await sleep(300);
        const html = await fetchHtml(port);
        assertLiteBranding(html, packagedVersion);
        assert(!html.includes('Superpowers Lite vunknown'), 'packaged plugin should not fall back to unknown version');
      });
    } finally {
      cleanup(fixture.root);
    }
  });

  await test('legacy Superpowers telemetry opt-out keeps the same offline branding', async () => {
    const port = 3453;
    const dir = '/tmp/brainstorm-branding-disabled';
    await withServer({ port, dir, env: { SUPERPOWERS_DISABLE_TELEMETRY: 'true' } }, async () => {
      writeFragment(dir);
      await sleep(300);
      const html = await fetchHtml(port);
      assertLiteBranding(html);
    });
  });

  await test('legacy yes opt-out keeps waiting-screen branding offline', async () => {
    const port = 3454;
    const dir = '/tmp/brainstorm-branding-disabled-waiting';
    await withServer({ port, dir, env: { SUPERPOWERS_DISABLE_TELEMETRY: 'yes' } }, async () => {
      const html = await fetchHtml(port);
      assertLiteBranding(html);
    });
  });

  await test('Claude telemetry opt-out keeps branding offline', async () => {
    const port = 3455;
    const dir = '/tmp/brainstorm-branding-claude-disable-telemetry';
    await withServer({ port, dir, env: { DISABLE_TELEMETRY: 'true' } }, async () => {
      writeFragment(dir);
      await sleep(300);
      const html = await fetchHtml(port);
      assertLiteBranding(html);
    });
  });

  await test('Claude non-essential traffic opt-out keeps branding offline', async () => {
    const port = 3456;
    const dir = '/tmp/brainstorm-branding-claude-disable-nonessential';
    await withServer({ port, dir, env: { CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC: '1' } }, async () => {
      const html = await fetchHtml(port);
      assertLiteBranding(html);
    });
  });

  console.log(`\n--- Results: ${passed} passed, ${failed} failed ---`);
  if (failed > 0) process.exitCode = 1;
}

main().catch((err) => {
  console.error('Test failed:', err);
  process.exit(1);
});
