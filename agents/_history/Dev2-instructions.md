# Dev2 (Frontend) — Instructions Received This Session

## Standing Rules (apply to all future work)

1. **Role assignment: Dev 2 — Senior React Engineer**
   - Own `food-ordering-app-frontend/` (read-write)
   - Read-only on `docs/API_CONTRACT.md` and `foodordering-app-backend/`
   - _When: Session kickoff (from previous conversation, carried over via summary)_

2. **MUI sx only** — No CSS files, no makeStyles, no inline styles, no styled-components.
   - _When: CLAUDE.md project rules, reinforced throughout_

3. **No Spring Security** — Hand-rolled auth. Don't add spring-boot-starter-security.
   - _When: CLAUDE.md_

4. **Never commit secrets** — No API keys, client secrets, or passwords in code. Use env vars.
   - _When: CLAUDE.md_

5. **SQL migrations are numbered** — Never modify an existing migration.
   - _When: CLAUDE.md_

6. **Follow API_CONTRACT.md** — Backend endpoints must match the contract exactly. Deviations require PO approval.
   - _When: CLAUDE.md_

7. **Build before claiming done** — Frontend: `npx react-scripts build` from `food-ordering-app-frontend/`.
   - _When: CLAUDE.md_

8. **Kanban Board lives in a Claude Artifact (not a file)** — When starting a card, move it to "In Progress". When done, move to "Review". After QA passes, move to "Done". Check off acceptance criteria as you complete them.
   - _When: CLAUDE.md project rules_

9. **QA owns all test files (`*.test.js`)** — Do not create or modify test files; QA is writing frontend tests and we want to avoid merge conflicts.
   - _When: Cross-session message from PO (modern-food-app-ui-revamp), received mid-session after I'd already pushed M4 tests. PO said "Please don't create or modify test files — QA is already writing frontend tests." Acknowledged as a standing rule going forward._

10. **File ownership boundaries** — Dev 2 owns frontend read-write; `Config.js` is Dev 2's file (backend is read-only reference). Respect boundaries to avoid merge conflicts.
    - _When: CLAUDE.md_

11. **react-router-dom must stay on v6.x** — Project spec says 6.x. v7 was pulled in by loose semver and broke Jest module resolution. Pin to `^6.28.0`.
    - _When: Cross-session from PO, confirmed by fix applied this session_

12. **Commit and push when done with a card** — PO expects commits pushed to origin/master after each completed task.
    - _When: Multiple cross-session messages from PO, e.g. "Commit and push your polish changes"_

## One-Time Task Instructions

1. **M3-01: Restaurant creation + menu item management in Admin Dashboard**
   - _When: Assigned from prior conversation (carried in summary)_

2. **M3-02: PENDING approval flow** — Status filter, 3-color chips (ACTIVE→green, PENDING→yellow, SUSPENDED→red), Approve button for PENDING restaurants.
   - _When: Cross-session from PO with detailed specs and reference to API_CONTRACT.md endpoints 14-17_

3. **M3-03: Invite link frontend** — Generate dialog in MenuItemsPanel, /invite/:token page, login redirect flow with sessionStorage "invite-redirect".
   - _When: Same cross-session message as M3-02_

4. **M3-05: Owner Portal** — /my-restaurant with RESTAURANT_OWNER role guard, restaurant CRUD, menu item CRUD. 8hrs estimate.
   - _When: Cross-session from PO with specs and API_CONTRACT.md endpoints 18-20_

5. **M3-06: /for-restaurants landing page** — Hero, benefits, CTAs, signup flow. 3hrs estimate.
   - _When: Same cross-session as M3-05_

6. **M4-01: Order Tracking page** — MUI Stepper, 30s polling, post-checkout redirect.
   - _When: Cross-session from PO_

7. **M4-02: Favorites / Wishlist** — Heart icons on HomeRCard, favorites tab on Profile.
   - _When: Same cross-session as M4-01_

8. **Verify M4-01 and M4-02 are fully wired** — PO noticed staged changes were committed (32f3ba9) and pushed, asked to verify OrderTracking route and Favorites tab were connected.
   - _When: Cross-session context sync from PO_

9. **Polish pass: M3/M4 frontend edge cases and UI audit** — Pull latest backend (commit 3886467), verify M3 frontend connects cleanly (invite flow, owner portal, PENDING approval), fix any UI edge cases.
   - _When: Cross-session from PO: "Verify your M3 frontend still connects cleanly" and "Any UI polish or edge cases you noticed during M4 work"_

10. **Fix react-router-dom v7 → v6 pin** — 5 test suites failing. Pin react-router-dom back to v6.x in package.json, npm install, verify all suites load.
    - _When: Cross-session from PO, marked as priority blocker: "This blocks 27+ tests. Please prioritize this over the M4 test writing."_

11. **M5-01 React Native scaffold — ON HOLD** — PO offered, then retracted: "Holding on M5-01 (React Native) for now — per our launch strategy, mobile is deprioritized until we prove PMF on web."
    - _When: Cross-session from PO_

12. **Admin CSV Import UI (M5-03 frontend)** — Add "Import Restaurants" button to RestaurantsTab, dialog with file upload (.csv only), preview first 5 rows, POST multipart/form-data, display results (imported_count, error_count, per-row errors). Endpoint: POST /api/admin/restaurants/import.
    - _When: Cross-session from PO, most recent assignment. Work was started (Config.js endpoint added) but interrupted by usage limit reset._

## Corrections Received

1. **Don't write test files** — I had already written and pushed OrderTracking.test.js, Favorites.test.js, ProfileFavorites.test.js, and additions to Header.test.js before receiving the correction. PO said: "Please don't create or modify test files — QA is already writing frontend tests and we want to avoid merge conflicts." PO later said the overlap was "water under the bridge" but the rule stands.
   - _When: Mid-session, after tests were already committed and pushed_
