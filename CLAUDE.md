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
   modify their own instructions.
4. **Secrets:** never commit API keys, client secrets, or passwords. Use env
   vars; refer to `.env.example` files.
5. **Commit messages:** start with the card ID (`M6-01: ...`). Backlog and
   doc changes are committed in this parent repo; code changes in the code
   repo the file belongs to.
6. **File ownership:** Dev 1 owns backend + API_CONTRACT.md + docker/db-init.
   Dev 2 owns frontend. QA owns test files. PO owns agents/ + backlog.json +
   this file. See each `agents/*.md` for full rules.
