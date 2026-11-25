# Food Ordering App — Project Guide

## Project Structure

```
food-ordering-app/                          # Root (NOT a git repo)
├── foodordering-app-backend/               # Git repo — Spring Boot backend
│   ├── pom.xml                             # Parent POM (multi-module Maven)
│   ├── FoodOrderingApp-api/                # REST controllers, models, application.yaml
│   │   └── src/main/java/.../api/
│   │       └── controller/                 # All REST controllers
│   ├── FoodOrderingApp-service/            # Business logic, entities, DAOs
│   │   └── src/main/java/.../service/
│   │       ├── business/                   # Service classes
│   │       ├── dao/                        # Data access (JPA)
│   │       ├── entity/                     # Hibernate entities
│   │       └── common/                     # Shared utilities, error codes
│   └── FoodOrderingApp-db/                 # DB scripts
│       └── src/main/resources/sql/         # tables.sql, V2__google_sso.sql, etc.
├── food-ordering-app-frontend/             # Git repo — React frontend
│   ├── package.json                        # npm (no yarn)
│   ├── public/index.html
│   └── src/
│       ├── FoodOrderingApp.js              # Router + ScrollToTop
│       ├── screens/                        # Page-level components
│       │   ├── home/ checkout/ details/ profile/ login/
│       │   └── admin/                      # (M1-08: new)
│       ├── common/                         # Shared components
│       │   ├── header/ footer/ notification/ layout/
│       │   └── utils/Config.js             # API endpoints registry
│       └── theme/
│           ├── brand.js                    # App name, tagline, Google Client ID
│           └── theme.js                    # MUI createTheme
└── docs/
    └── API_CONTRACT.md                     # Milestone 1 & 3 endpoint specs
```

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Backend | Spring Boot | 3.3.6 |
| Java | Temurin | 17 |
| Build | Maven (global `mvn`, no wrapper) | — |
| DB | PostgreSQL | 17 (port **5434**) |
| ORM | Hibernate 6 / Jakarta EE | — |
| API Docs | SpringDoc OpenAPI | 2.3.0 |
| Frontend | React | 18.2.0 |
| UI Library | MUI v5 | 5.15.x |
| Routing | react-router-dom | 6.x |
| Node | — | 22 |
| Package Manager | npm (no yarn) | — |

## Database

- **Host:** localhost
- **Port:** 5434 (not default 5432)
- **Database:** restaurantdb
- **User:** postgres / password
- **JAVA_HOME:** `/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home`

## Auth System

Custom hand-rolled auth (NOT Spring Security):
- `JwtTokenProvider` generates JWT tokens
- Tokens stored in `customer_auth` table as opaque values
- Login: Basic auth → returns Bearer access-token in response header
- Protected endpoints: Bearer token in `Authorization` header
- Google SSO: POST /api/customer/google-login with Google ID token
- Roles: `role` column on `customer` table (after M1-03 migration)

## Styling

- **Single approach:** MUI `sx` prop everywhere (no CSS files, no makeStyles, no inline styles)
- **Theme:** Poppins font, coral-red `#E23744` primary, amber `#FF9800` secondary
- **Branding:** Configurable via `src/theme/brand.js`

## Running Locally

```bash
# Backend (from foodordering-app-backend/)
JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home mvn clean install -DskipTests
JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home java -jar FoodOrderingApp-api/target/FoodOrderingApp-api-1.0-SNAPSHOT.jar

# Frontend (from food-ordering-app-frontend/)
npm start
```

## File Ownership Rules

Agents must respect these boundaries to avoid merge conflicts:

### Dev 1 — Backend
**Owns (read-write):**
- `foodordering-app-backend/` — all Java source, pom.xml files, application.yaml, SQL migrations
- `docs/API_CONTRACT.md` — keep in sync when adding/changing endpoints

**Read-only:**
- `food-ordering-app-frontend/src/common/utils/Config.js` — reference only; Dev 2 owns this file

### Dev 2 — Frontend
**Owns (read-write):**
- `food-ordering-app-frontend/` — all JS/JSX source, package.json, public/
- `food-ordering-app-mobile/` — (future, M5+)

**Read-only:**
- `docs/API_CONTRACT.md` — consume specs; request changes via PO

### QA
**Owns (read-write):**
- Test files (`*Test.java`, `*.test.js`)

**Read-only:**
- All source (for writing tests against)

### PO
**Owns (read-write):**
- `docs/API_CONTRACT.md` — full control (endpoint specs)
- `CLAUDE.md` — project rules
- Kanban Board (Claude Artifact) — full control (cards, priorities, milestones)

## Agent Rules

1. **Kanban Board:** Feature tracking lives in a Claude Artifact (not a file). When starting a card, move it to "In Progress". When done, move to "Review". After QA passes, move to "Done". Check off acceptance criteria as you complete them.
2. **Never commit secrets:** No API keys, client secrets, or passwords in code. Use env vars.
3. **Build before claiming done:**
   - Backend: `mvn clean install` from `foodordering-app-backend/`
   - Frontend: `npx react-scripts build` from `food-ordering-app-frontend/`
4. **Follow API_CONTRACT.md:** Backend endpoints must match the contract exactly (paths, methods, request/response shapes). Deviations require PO approval.
5. **No Spring Security:** We use hand-rolled auth. Don't add spring-boot-starter-security.
6. **MUI sx only:** No CSS files, no makeStyles, no inline styles, no styled-components.
7. **SQL migrations are numbered:** `V3__rbac.sql`, `V4__email_unique.sql`, etc. Never modify an existing migration.
