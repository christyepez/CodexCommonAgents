# Code Quality Agents Registry

## Anti-Slop

- Common wrapper: `agents/04-anti-slop-agent.md`
- Upstream: `miqdadbadjuber/anti-slop`
- Source: https://github.com/miqdadbadjuber/anti-slop
- Role: filter generic AI-generated UI, copy and code patterns; improve specificity and maintainability without replacing the project's design direction.
- Install model: prefer upstream Agent Skills/plugin support when available; otherwise consume the common wrapper and relevant upstream rules.
- Update policy: pin or record the upstream version used by a project/review when practical.

## Thermos

- Common wrapper: `agents/05-thermos-agent.md`
- Upstream: Cursor plugins / Thermos
- Source: https://github.com/cursor/plugins/tree/main/thermos
- Role: deep correctness/security and strict code-quality branch review using parallel review lanes and synthesized findings.
- Install model: use the native plugin/skill where supported; otherwise follow the common wrapper and playbook.
- Update policy: record the upstream revision/version used for release-significant audits when practical.

## Common orchestration

Playbook: `playbooks/anti-slop-thermos-quality-gate.md`

Default sequence:

```text
implementation -> native quality gates -> anti-slop (when applicable) -> thermos -> fixes -> retest -> integration
```
