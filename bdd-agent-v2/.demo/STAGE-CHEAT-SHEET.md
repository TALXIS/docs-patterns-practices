# 🎤 STAGE CHEAT SHEET — Can LLMs finally solve testing?

**60 min · DynamicsMinds 2026 · Portorož**
**App:** `dynamicsminds26demo.crm4.dynamics.com`

---

## ACT I — THE PROBLEM (0:00–5:00)

### Beat 0 · Opening Hook (0:00–2:30) 🔴
**SCREEN:** Slide → terminal
**SAY:** "AI is both the best tool for generating tests AND inherently motivated to make them pass. That's the fundamental conflict."
**DO:** Nothing technical — pure narration
**SLIDE:** "The Conflict: AI generates tests AND games them"

---

### Beat 1 · Tour the App (2:30–5:00) 🔴
**SCREEN:** Browser — warehouse app
**DO manually:**
1. Open Warehouse Items grid → show columns (SKU, Qty, Category, Location)
2. Open "Gadget B" → show form, tabs, transaction subgrid
3. Click "Check Stock Levels" ribbon → show alert
4. Navigate to Transactions → New → Outbound, Gadget B, qty: 999 → Save
5. **Show plugin error:** "Not enough product in stock. Available: 5, requested: 999."
6. Cancel/discard

**SAY while navigating:**
- "Scaffolded from templates — 15 dotnet new commands, zero manual XML"
- "Two plugins: validate stock, subtract quantity"
- *On error:* "That's PreValidation firing before the record saves"

---

## ACT II — RETROACTIVE TESTING (5:00–25:00) ⭐ MAIN ACT

### Beat 2 · Write Gherkin (5:00–10:00) 🔴
**SCREEN:** Terminal
**VOICE COMMAND:**
> "Write Gherkin behavior scenarios that document this warehouse app. Cover: navigating to items, verifying the grid, opening a record, checking fields, creating transactions, the insufficient stock error, and the stock level ribbon button."

**EXPECTED:** Agent creates `.feature` files with Given/When/Then
**SAY while waiting:**
- "95% of AI-generated Gherkin was rated helpful in BMW study"
- "AI can't corrupt what it can't see — the behavior spec is the firewall"
**BACKUP:** Pre-written `.feature` files → `./backup-demo.ps1 -Beat 3`

---

### Beat 3 · Set Up Test Project (10:00–12:00) 🔴
**VOICE COMMAND:**
> "Set up a BDD test project using the Playwright-based test template. Copy the feature files in."

**EXPECTED:** `dotnet new pp-test-ui`, copies features
**BACKUP:** `./backup-demo.ps1 -Beat 3`

---

### Beat 4 · Discover Bindings (12:00–17:00) 🔴 ⭐ AHA MOMENT
**VOICE COMMAND:**
> "Check what pre-built test bindings are available for standard MDA pages. Map our Gherkin steps to those existing bindings. Only write custom code for steps that don't have pre-built support."

**EXPECTED:** Agent calls `txc guide_testing` MCP → maps steps → reports "Zero custom code needed for standard pages"
**SAY:**
- "130+ pre-built step patterns — navigation, forms, grids, command bar, tabs"
- "The agent didn't write ANY code — it just mapped Gherkin to existing bindings"
- "Pre-built for standard MDA, AI-generated only for custom — 80/20 split"
- **"No LLM runs at test execution time. Generated code is deterministic."**
**BACKUP:** Pre-captured binding catalog output

---

### Beat 5 · Custom Steps (17:00–20:00) 🟡
**VOICE COMMAND:**
> "For the plugin error validation — generate a custom step to verify the error message dialog."

**EXPECTED:** Agent generates `WarehouseCustomSteps.cs` with Playwright selectors for MDA error dialog
**SAY:** "This is the ONLY code the agent had to generate. Everything else was pre-built."

---

### Beat 6 · Run Tests + Report (20:00–25:00) 🔴
**VOICE COMMAND:**
> "Run the BDD tests. Generate the test report."

**EXPECTED:** `dotnet test` → browser automation visible → Cucumber HTML report
**SAY while tests run:**
- "Watch the browser — the agent navigates, fills forms, clicks buttons"
- *On report:* "Screenshots on failure. Playwright traces replay the entire session."
- "This goes into CI/CD. Same format as any Cucumber project."
**BACKUP:** `./backup-demo.ps1 -Beat 6`

---

## ACT III — TEST-DRIVEN NEW FEATURE (25:00–40:00)

### Beat 7 · Gherkin First (25:00–28:00) 🔴
**VOICE COMMAND:**
> "New feature: transfers between locations. Write Gherkin first — happy path, error case, verify both locations update."

**EXPECTED:** New `.feature` with transfer scenarios

---

### Beat 8 · Implement via Subagent (28:00–35:00) 🔴
**VOICE COMMAND:**
> "Implement the transfer feature. New optionset value, two lookup fields, transfer plugin, form update. Deploy."

**EXPECTED:** Subagent delegation visible → schema → plugin → form → deploy
**SAY:** "Notice the decomposition: schema first, then plugin, then form, then deploy"
**⚠️ HIGH RISK** — backup: `./backup-demo.ps1 -Beat 9`

---

### Beat 9 · Green (35:00–40:00) 🔴
**VOICE COMMAND:**
> "Generate bindings for transfer scenarios. Run all tests."

**EXPECTED:** All tests green → updated report
**SAY:** "TDD cycle complete: wrote tests first, implemented, tests pass."

---

## ACT IV — ADVANCED (40:00–52:00)

### Beat 10 · Healing (40:00–45:00) 🔴
**PREP:** Change the plugin error message text BEFORE this beat
**VOICE COMMAND:**
> "Run the tests. When they fail, diagnose whether the app or test is wrong. Fix it."

**EXPECTED:** Test fails → agent reads screenshot → diagnoses → fixes → green
**SAY:** "Three questions: Is the app broken? Is the test outdated? Is it a selector issue?"

---

### Beat 11 · Exploratory (45:00–48:00) 🟡 *cuttable*
**VOICE COMMAND:**
> "Do exploratory testing — browse freely, try edge cases, try to break it."

---

### Beat 12 · Debug Interception (48:00–52:00) 🟡 *first to cut*
**VOICE COMMAND:**
> "Intercept the JS web resource, redirect to a local file with console.log."

---

## ACT V — CLOSING (52:00–60:00)

### Beat 13 · Recap 🔴
**SAY:**
1. AI games its own tests — you need the right architecture
2. Gherkin-first = specs that guide AND validate AI
3. Pre-built bindings for standard MDA + AI-generated for custom
4. Three agents: planner → binder → healer
5. No LLM at execution time — deterministic in CI/CD
6. **Start with Gherkin today — even without automation, it helps**

**REPOS:** bdd-agent-v2, sample warehouse repo, TALXIS TestKit, TALXIS DevKit CLI

---

## ⏱️ IF RUNNING BEHIND

| Behind | Cut |
|--------|-----|
| 3 min | Beat 12 (debug interception) |
| 5 min | + Beat 11 (exploratory) |
| 8 min | + compress Beat 8 (use backup) |
| 10+ min | Skip Act IV entirely → Beat 9 → Beat 13 |

**NEVER CUT:** Beats 2–6 (retroactive testing) = the demo's core

---

## 🔧 RECOVERY

| Problem | Fix |
|---------|-----|
| Auth expires | Re-auth cookies (30s) |
| Agent hallucinates | "Let me be more specific…" + constrained prompt |
| MCP fails | Show pre-captured output |
| Tests won't compile | `./backup-demo.ps1 -Beat 6` |
| Deployment fails (Beat 8) | `./backup-demo.ps1 -Beat 9` |
| Environment down | Local-only: code + pre-recorded test run |

---

## 📊 KEY NUMBERS TO MENTION

- **130+** pre-built step bindings for standard MDA
- **~300 tokens** per Playwright accessibility snapshot (vs 5,000+ raw DOM)
- **95%** of AI-generated Gherkin rated helpful (BMW study)
- **40%** of AI-generated test scripts had semantic issues (BMW study)
- **80/20** pre-built bindings / AI-generated custom code split
- **0** LLM calls at test execution time
