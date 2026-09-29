# Global instructions

## Personal context (Notion)
My durable cross-project context lives in Notion: "Claude Context" hub page
https://app.notion.com/p/3e9485249bb58090b42ac2b17e4320e3
- The hub has a 1–2 line summary per area (About Me, Preferences, Homelab, PC,
  Home, ...) linking to one subpage each. Open the hub by URL, not search.
- For tasks where my background, preferences, homelab or project history
  matters, read the hub, then only the subpages you need. Skip it for
  trivial or self-contained tasks.
- Keep it accurate:
  - New durable fact (likely to matter for months) → add it to the relevant
    subpage, and update its hub summary if needed.
  - Page contradicted by something you can verify (repo, config, command
    output) → fix it.
  - Contradicted only by inference, or about my preferences/plans → ask me first.
  - Don't reword or reorganize for style.
  - Replace outdated info rather than appending contradictions.
  - Tell me in one line whenever you change something.
- New area with no subpage → ask before creating one; then add it to the hub.
- Notion unreachable → work from the Core section below and tell me; don't
  fall back to local memory.
- Never store secrets in Notion.
- Use Notion for cross-project facts, not the local Claude Code memory folder.

## Projects
- In any repo, read README.md at the start of the session before doing
  anything else. Project facts live there (not in a repo CLAUDE.md), and
  project-level updates go there too.
- Feature work:
  - Starting a new feature → create `.local/<feature-name>.md` in the repo with
    goal, decisions, status and next steps. Keep it updated as work progresses.
  - At the start of a session, check `.local/` for in-progress features.
  - Feature done → move it to `.local/complete/<feature-name>_mm_dd_yy.md`.

## Core (always true, no need to fetch)
- James: Senior Manager at IBM (SEO, GEO/AEO, AI chat, content automation), Brooklyn.
- Codes in Go and TypeScript/Svelte; Python via uv. Primary machine: M4 MacBook Air; dotfiles via chezmoi.
- Homelab: Unraid + Komodo + Traefik, UniFi (UDM SE), repo jamesfpate/homelab.
- Wants direct, terse, specific answers. Push back when reasoning is weak; no deference or hype.
- Work AI tools are limited to IBM-approved paths; don't assume personal tooling applies to work.

## Git
- Always ask before committing or pushing.
- Never add Claude as co-author or add AI attribution lines (Co-Authored-By,
  Claude-Session, "Generated with Claude Code") to commits or PRs.
