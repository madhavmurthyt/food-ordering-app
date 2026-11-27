# QA Agent — Instructions History

All instructions given to the QA agent beyond the original kickoff prompt, in chronological order.

---

## 1. E2E timing gate
**Instruction:** "make sure E2E validation is done only after Dev 1 and Dev 2 agents are done"
**When/Why:** Immediately after the kickoff, when user gave the green light to start work. Ensures QA doesn't run E2E before code is ready.
**Type:** Standing rule

## 2. Watch the Kanban board
**Instruction:** "Dev1 and Dev2 keep updating the Kanban board once every task is done. You need to watch out"
**When/Why:** Mid-turn, early in session 1. User wanted QA to monitor the board for completed dev work rather than waiting for explicit pings.
**Type:** Standing rule

## 3. File bugs on Kanban, assign to correct dev
**Instruction:** "once you validate the E2E any issues have to be created in the kanban board itself.. FrontEnd assign to Dev1 and Backend assign to Dev2"
**When/Why:** Mid-turn, early in session 1. Established the bug-filing workflow. *(Note: Dev assignment was initially stated backwards — corrected in instruction #5.)*
**Type:** Standing rule

## 4. Dev 1 = Backend correction
**Instruction:** "ok Dev 1 is backend correction"
**When/Why:** Mid-turn, session 2. User corrected the assignment from instruction #3: **Dev 1 owns Backend, Dev 2 owns Frontend.** Bugs should be assigned accordingly.
**Type:** Standing rule (correction to #3)

## 5. QA must not fix dev issues
**Instruction:** "you will not fix any dev issues. assign it to Dev1 or Dev2"
**When/Why:** Mid-turn, during M2 E2E validation. QA had started investigating a backend bug and was about to fix it. User drew a hard line: QA identifies and files bugs, never fixes source code.
**Type:** Standing rule

## 6. QA must write frontend test automation
**Instruction:** "That is unacceptable. you are a QA Functional validation expert as well. You will right Front End automation"
**When/Why:** During M2, after QA ran only Playwright E2E tests and the home page had errors. User was frustrated that QA hadn't written frontend unit tests (Jest/React Testing Library). Expanded QA scope to include writing `*.test.js` files, not just E2E.
**Type:** Standing rule (scope expansion)

## 7. Always push only your own changes
**Instruction:** "always push the changes ONLY you made"
**When/Why:** Mid-turn, during the current session, after QA committed test fixes. The working tree had other people's changes (README.md, package-lock.json, restart.sh). User wanted QA to stage and push only QA-owned test files, never other developers' uncommitted work.
**Type:** Standing rule

---

## Cross-session instructions from PO (modern-food-app-ui-revamp)

These came via `SendMessage` from the PO's session, not directly from the user, but were treated as team directives.

### P1. Don't wait for M3-08 — start writing tests now
**Instruction:** "Don't wait for M3-08 — start working now. You're responsible for both functional validation and test automation." Listed specific backend tests (endpoints 10–20), frontend tests (CreateRestaurantDialog, MenuItemsPanel, RestaurantsTab, InvitePage), and E2E test plan prep.
**When/Why:** PO session, after assigning M3-08 card. PO wanted continuous validation, not a waterfall handoff.
**Type:** Standing rule for M3+ milestones

### P2. Backend issues → Dev 1, Frontend issues → Dev 2
**Instruction:** Reiterated the bug assignment rule (aligns with user instruction #4/#5).
**Type:** Standing rule (reinforcement)

### P3. Hold off on react-router-dom-dependent tests
**Instruction:** "Hold off on writing new frontend tests for those affected components until Dev 2 pushes the fix — you'll know it's done when package.json pins react-router-dom to ^6.x."
**When/Why:** After QA reported the react-router-dom v7 module resolution bug. PO wanted to avoid wasted work on tests that can't run.
**Type:** One-time directive (resolved when Dev 2 pushed the fix)

### P4. Finish M3 E2E before M4
**Instruction:** "Finish M3-08 first, then add M4 E2E to your queue."
**When/Why:** After M4 backend landed. PO established priority order.
**Type:** One-time directive (task sequencing)
