# Privacy

Superpowers Lite does not intentionally collect or transmit usage telemetry.

## Runtime behavior

- Skills are local instruction files read by the coding harness.
- The optional brainstorming visual companion serves HTML and WebSocket traffic
  from a local Node.js process. Its pages use local text branding and do not
  load a tracking pixel, remote logo, analytics script, or web font.
- The visual companion uses a per-session secret in its URL and cookie to
  authorize HTTP and WebSocket access.
- By default it binds to `127.0.0.1`. Users who explicitly change
  `BRAINSTORM_HOST` are responsible for the resulting network exposure.
- Superpowers Lite does not operate a project telemetry or analytics service.

Your coding harness and model provider may independently process prompts,
files, tool calls, or diagnostics under their own policies. Superpowers Lite
does not control those services.

## Network access

Installation, update, GitHub, package-manager, and explicit web-research
commands can access their named services. Those actions are distinct from
automatic usage telemetry. Review commands before approving them and follow
your harness's network and permission settings.

## Data in reports

Issue forms ask for environment and reproduction information. Before posting,
remove credentials, personal data, private source code, local home paths,
session identifiers, and unrelated conversation history. Use
[GitHub Private Vulnerability Reporting](SECURITY.md) for security-sensitive
material.

## Changes to this policy

Any future telemetry or hosted service requires an explicit policy update,
clear disclosure in the README, and an opt-in design before release.
