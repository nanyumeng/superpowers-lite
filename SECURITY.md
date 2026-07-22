# Security Policy

## Supported versions

During pre-release development, security fixes are applied to `main`. After the
first tagged release, the latest Lite release line and `main` will receive
security fixes; older release lines are unsupported unless an advisory says
otherwise.

## Report a vulnerability privately

Do not open a public issue for a suspected vulnerability or include exploit
details in a public discussion.

Use GitHub Private Vulnerability Reporting:

https://github.com/nanyumeng/superpowers-lite/security/advisories/new

Include the affected revision, harness, impact, reproduction steps, and any
suggested mitigation. Remove unrelated secrets and personal data from logs.

Private Vulnerability Reporting is the preferred channel. If the
**Report a vulnerability** action is unavailable, email
[nanyvmeng1021@gmail.com](mailto:nanyvmeng1021@gmail.com) with the subject
`[SECURITY] Superpowers Lite`. Do not open a public issue containing sensitive
details.

## Scope

Relevant reports include vulnerabilities in hooks, local servers, package or
installation scripts, path handling, command execution, session bootstrap, and
credential or project-data exposure caused by Superpowers Lite.

Model mistakes, prompt-quality disagreements, and ordinary harness bugs are not
security vulnerabilities unless they cross an authorization, confidentiality,
or code-execution boundary. See [SUPPORT.md](SUPPORT.md) for routing.

The maintainer will validate the report, coordinate a fix and disclosure when
appropriate, and credit reporters who want public acknowledgement.
