Spawn a dedicated PO Agent (or act in strict Product Owner mode) to review our Kanban board and prepare Milestone 1. Do NOT write any Java or React application code yet.

Execute these 4 steps in order:

1. **Audit the Existing Codebase:**
   - Inspect our Spring Boot backend and React frontend directories to identify our exact folder paths, build tools (Maven/Gradle, npm/yarn), database setup, existing User/Order/Menu entities, and how Google OAuth2 SSO is currently wired.

2. **Review & Upgrade the Kanban Board (`/docs/KANBAN.md`):**
   - Read the Kanban board file inside `/docs/` (whether saved as `KANBAN.md` or `.jsx`). If it is `.jsx`, convert and save a clean, structured `/docs/KANBAN.md`.
   - Perform a gap analysis for expanding our basic food ordering app into a full DoorDash-style platform. Add any missing tasks for:
     * Role-Based Access Control (`CUSTOMER`, `RESTAURANT_OWNER`, `DRIVER`, `ADMIN`).
     * Expanding SSO beyond Google (e.g., GitHub/Facebook OAuth2 + standard email/password login) without breaking existing Google login.
     * Admin Dashboard (approve/suspend restaurants, manage user roles, monitor platform orders).
   - Tag every card with an owner (`[PO]`, `[Dev 1 - Backend]`, `[Dev 2 - Frontend]`, or `[QA]`), group them into Milestones (starting with Milestone 1), mark dependencies/blockers, and add clear Acceptance Criteria to each card.

3. **Generate `/docs/API_CONTRACT.md` for Milestone 1:**
   - Define exact REST endpoints, HTTP methods, Spring Security role guards, request payloads, and JSON response schemas so Dev 1 and Dev 2 can build in parallel without conflicts.

4. **Update Root `CLAUDE.md`:**
   - Create or update `CLAUDE.md` in the repo root with our verified folder paths, tech stack details, strict file-ownership rules for Dev 1, Dev 2, and QA, and a rule requiring agents to update card statuses in `/docs/KANBAN.md`.

When finished, present a concise summary of:
- What you found in the existing codebase
- Key additions/changes made to `/docs/KANBAN.md`
- Any open product decisions I need to confirm before you unlock Dev 1 and Dev 2.
