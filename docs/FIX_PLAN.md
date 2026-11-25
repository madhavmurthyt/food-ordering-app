# Fix Plan — Making the Food Ordering App Work

## Current State

The app is a full-stack food ordering application built ~4+ years ago with Spring Boot 2.3.2 (Java) + React 16 (CRA). Both codebases are structurally complete — controllers, services, DAOs, entities, and frontend screens all exist. The primary blockers are **environment setup** and **dependency age**, not missing features.

---

## Phase 1: Environment Setup (Get It Running)

### 1.1 Install Maven
```
brew install maven
```
Maven is required to build the backend — it's the only missing tool. Java 17 and PostgreSQL 17 are already installed.

### 1.2 Set Up PostgreSQL Database
The app expects PostgreSQL on port **5434** (non-standard). Either:
- **Option A**: Start PostgreSQL on port 5434
  ```
  pg_ctl -D /opt/homebrew/var/postgresql@17 -o "-p 5434" start
  ```
- **Option B**: Change the port to 5432 in both:
  - `FoodOrderingApp-db/src/main/resources/config/localhost.properties` (line 1: `server.port=`)
  - `FoodOrderingApp-api/src/main/resources/application.yaml` (line 12: url suffix)

Then create the database:
```sql
createdb -p 5434 restaurantdb
```

### 1.3 Run Database Setup (Tables + Seed Data)
```
cd foodordering-app-backend/FoodOrderingApp-db
mvn process-resources -Psetup
```
This runs `tables.sql` then `insert.sql` against the DB.

### 1.4 Build & Run Backend
```
cd foodordering-app-backend
mvn clean install -DskipTests
cd FoodOrderingApp-api
mvn spring-boot:run
```
Backend should start on `http://localhost:8080/api/`.

### 1.5 Install & Run Frontend
```
cd food-ordering-app-frontend
npm install
npm start
```
Frontend should start on `http://localhost:3000`.

---

## Phase 2: Compatibility Fixes (Will Likely Break)

### 2.1 Spring Boot 2.3.2 + Java 17 Compatibility
Spring Boot 2.3.2 was designed for Java 8-11. Running on Java 17 will likely fail due to:
- **Removed `javax` packages** — Java 17 removed `javax.annotation`, `javax.persistence`, etc.
- **Illegal reflective access** — Hibernate/Spring internals hit Java module boundaries

**Fix options** (in order of preference):
1. **Upgrade Spring Boot to 3.x** (requires changing `javax.*` → `jakarta.*` imports in all entities/DAOs)
2. **Add `--add-opens` JVM flags** and add JAXB/javax dependencies explicitly
3. **Install JDK 11** alongside JDK 17 and use it for this project

### 2.2 Swagger Codegen Compatibility
Swagger Codegen 2.4.15 may fail with newer Java. The generated model classes in `target/generated-sources/` already exist from a previous build, so this might work — but a fresh build needs codegen to run.

**Fix**: If codegen fails, upgrade to `swagger-codegen-maven-plugin` 3.x or switch to OpenAPI Generator.

### 2.3 `MediaType.APPLICATION_JSON_UTF8_VALUE` Deprecation
`OrderController.java` uses `MediaType.APPLICATION_JSON_UTF8_VALUE` which was deprecated in Spring 5.2 and may cause issues.

**Fix**: Replace with `MediaType.APPLICATION_JSON_VALUE` in `OrderController.java` lines 131-132.

### 2.4 Frontend: React 16 + react-scripts 5.0.1
`react-scripts` 5.0.1 requires Webpack 5 and may have issues with some older dependencies on Node 22. Common error: `digital envelope routines::unsupported`.

**Fix**: If build fails, set `NODE_OPTIONS=--openssl-legacy-provider` or upgrade `react-scripts` and React together.

### 2.5 `createMuiTheme` Deprecation
`Header.js` uses `createMuiTheme` which was renamed to `createTheme` in MUI v5. This works in v4 but will log warnings.

**Fix**: No action needed unless upgrading MUI.

---

## Phase 3: Bug Fixes (Code Issues Found)

### 3.1 Frontend: Header Logout Doesn't Call Server
`Header.js:logout()` only clears `sessionStorage` — never calls `POST /api/customer/logout`. The JWT remains valid server-side until expiry.

**Fix**: Add server logout call before clearing session storage.

### 3.2 Frontend: Hardcoded API URLs
Three different places define the backend URL:
- `Config.js`: `endpointPrefix: "http://localhost:8080"`
- `FoodOrderingApp.js`: `this.baseUrl = "http://localhost:8080/api/"`
- `Home.js`: hardcoded `"http://localhost:8080/api/restaurant"` and `"http://localhost:8080/api/restaurant/name/"`

**Fix**: Consolidate all API calls to use `Config.js` + `ApiHelper.js`.

### 3.3 Frontend: Cart State Mutation
`Details.js:addToCartHandler()` directly mutates state objects (e.g., `this.state.cartItems.push(...)`, modifying objects in the array without setState). This causes React rendering bugs.

**Fix**: Use immutable state updates — create new arrays/objects before calling `setState`.

### 3.4 Frontend: `onSignUpClick` Validation Logic Inverted
`Header.js` line 300: the condition `isAnyValidationFailed===false && isAnyRequiredFieldEmpty===false` is wrong because `isAnyValidationFailed` starts `true` and is set to `false` when validation fails. This means signup only proceeds when validation fails AND fields are empty — it's inverted.

**Fix**: Rename and fix the boolean logic so signup proceeds when all validations pass and all required fields are non-empty.

### 3.5 Backend: `RestaurantEntity.setNumberCustomersRated` Naming
`RestaurantService.java:68` calls `setNumberCustomersRated()` but the entity likely has `setNumberOfCustomersRated()` (based on the getter used on line 66). Verify and fix naming mismatch.

### 3.6 Backend: OrderController flatBuildingName Bug
`OrderController.java:80` maps `flatBuildingName` incorrectly:
```java
.flatBuildingName(orderEntity.getAddress().getUuid())  // BUG: should be getFlatBuilNo()
```

### 3.7 Profile Page Not Implemented
`Profile.js` is a stub — only renders header + text.

**Fix**: Implement profile page showing customer details with update name/password forms, using existing backend endpoints `PUT /customer` and `PUT /customer/password`.

---

## Phase 4: Modernization (Optional, Recommended)

### 4.1 Upgrade Spring Boot to 3.x
- Migrate `javax.*` → `jakarta.*` in all entities, DAOs, and configs
- Update `spring-boot-starter-parent` to 3.2.x
- Update PostgreSQL driver, Swagger → SpringDoc OpenAPI

### 4.2 Upgrade React to 18+
- Replace class components with functional components + hooks
- Upgrade Material-UI v4 → MUI v5
- Replace `react-router-dom` v5 → v6

### 4.3 Add Docker Compose
Create `docker-compose.yml` with:
- PostgreSQL container (port 5434)
- Backend container (port 8080)
- Frontend container (port 3000)
Makes setup one command: `docker compose up`.

### 4.4 Add `.env` / Environment Config
Replace hardcoded URLs with environment variables (`REACT_APP_API_URL`, Spring profiles).

---

## Execution Order

| Step | Task | Est. Time | Blocking? |
|---|---|---|---|
| 1 | Install Maven | 2 min | Yes |
| 2 | Set up PostgreSQL + create DB | 5 min | Yes |
| 3 | Run DB setup (tables + seed) | 2 min | Yes |
| 4 | Fix Java 17 compatibility (Phase 2.1) | 15-30 min | Yes |
| 5 | Fix `APPLICATION_JSON_UTF8_VALUE` (2.3) | 1 min | Likely |
| 6 | Build + start backend | 5 min | Yes |
| 7 | `npm install` + start frontend | 3 min | Yes |
| 8 | Fix OpenSSL issue if needed (2.4) | 2 min | Maybe |
| 9 | Fix signup validation bug (3.4) | 5 min | High-impact |
| 10 | Fix cart state mutation (3.3) | 10 min | Medium |
| 11 | Fix flatBuildingName bug (3.6) | 1 min | Low |
| 12 | Consolidate hardcoded URLs (3.2) | 10 min | Low |
| 13 | Add server logout call (3.1) | 5 min | Low |
| 14 | Implement Profile page (3.7) | 30 min | Low |
