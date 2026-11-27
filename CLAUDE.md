# Food Ordering App

## Layout

This is a git repo holding shared docs, agents, and infra. The two code
folders are separate git repos:

```
food-ordering-app/            # THIS repo
├── agents/                   # Agent instructions (human-edited only)
│   ├── POAgent.md            # Product Owner — /po
│   ├── Dev1.md               # Backend engineer
│   ├── Dev2.md               # Frontend engineer
│   └── QAAgent.md            # QA & validation
├── docs/
│   ├── backlog.json          # Single source of truth for all work
│   └── API_CONTRACT.md       # REST endpoint specs (Dev 1 owns; PO + Dev 2 read-only)
├── docker-compose.yml        # Full-stack local env
├── db-init/01-schema.sh      # DB seed script for Docker
├── foodordering-app-backend/ # Git repo — Spring Boot (see its own CLAUDE.md)
└── food-ordering-app-frontend/ # Git repo — React (see its own CLAUDE.md)
```

## Shared Rules

1. **Work tracking:** `docs/backlog.json` is the single source of truth.
   Cards flow: backlog → progress → review → done.
2. **API contract:** `docs/API_CONTRACT.md` is owned by Dev 1. PO and Dev 2
   are read-only; request changes via card notes.
3. **Agent files:** `agents/` is edited only by the human. Agents never
   modify their own instructions. Sole exception: the PO merges rules the
   human has marked APPROVED/CHANGED into POAgent.md (see its approval loop).
4. **Secrets:** never commit API keys, client secrets, or passwords. Use env
   vars (`.env`, gitignored).
5. **Commit messages:** start with the card ID (`M6-01: ...`). Backlog and
   doc changes are committed in this parent repo; code changes in the code
   repo the file belongs to.
6. **File ownership:** Dev 1 owns backend + API_CONTRACT.md + docker/db-init.
   Dev 2 owns frontend. QA owns test files. PO owns backlog.json card content;
   Dev/QA only change a card's col and ac ticks, and QA adds bug cards. The
   human owns agents/ and this file. See each `agents/*.md` for full rules.
7. **Token economy:** read only what the task needs, and keep output short.
   - `backlog.json`: query just the cards you need (`jq '.[] | select(.id=="M6-01")'`,
     or filter by owner/col); never load the whole file. Change cards with a
     targeted edit, not by rewriting the file.
   - `API_CONTRACT.md`: list headings first (`grep -n "^#"`), then read only
     the relevant section.
   - Never read `node_modules/`, `target/`, `build/`, `test-results/`, or
     `package-lock.json`.
   - Build/test output: show only failures and the summary (`| tail -40`).
   - Don't re-read a file already read in this run or echo file contents back.
   - Final report: what changed, what's left, open questions. No recap of steps.
