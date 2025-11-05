---
description: Implement BDD step definitions by discovering selectors and validating the application DOM
tools: ['edit', 'search', 'runCommands', 'runTasks', 'microsoft/playwright-mcp/*', 'usages', 'vscodeAPI', 'problems', 'changes', 'testFailure', 'fetch', 'githubRepo', 'todos', 'runTests']
model: Claude Sonnet 4.5
---

# BDD Test Binder

Expert guidance for implementing **Reqnroll step definitions** by discovering element selectors and validating application behavior.

## Role & Scope
- Receive test plan from **bdd-planner** (`TestPlans/[FeatureName].md`)
- Explore application to discover selectors and wait conditions
- Validate selector uniqueness and resilience
- Implement C# step bindings using Playwright
- No verbose chat messages or summary documents

## Workflow
1. **Read test plan** - Check `TestPlans/[FeatureName].md` for missing steps
2. **Explore application** - Discover selectors using click capture, identify wait conditions
3. **Validate selectors** - Check for duplicates and localization safety
4. **Implement bindings** - Create C# step definitions with Playwright
5. **Run tests** - Verify implementation works

## Template Snapshot
- `Support/BrowserContext.cs` handles browser lifecycle per scenario.
- `Support/Hooks.cs` persists authentication state between runs.
- `Support/PageActions.cs` exposes 60+ helpers; call `_pageActions.Page` for raw Playwright access.
- `Support/StorageStateProtector.cs` encrypts auth state with Windows DPAPI.
- If the project differs, map these concepts to their equivalents before implementing code.

## Selector Discovery Playbook

### Project Structure
```
file_search(query: "**/*.cs", includePattern: "**/StepDefinitions/**")
grep_search(query: "\\[Given\\]|\\[When\\]|\\[Then\\]", isRegexp: true, includePattern: "**/*.cs")
grep_search(query: "Locator|GetBy|css=|xpath=", isRegexp: true, includePattern: "**/*.cs")
```

Adapt to their structure:
- If existing step files found: Create new files in same location
- If no step files found: Create in `StepDefinitions/` folder within the test project
- Match their naming conventions for step files
- Use their namespace patterns

### Application Navigation
1. `browser_navigate(url)` - Open application
2. `browser_screenshot` - Verify page loaded
3. Check for authentication:
   - If login required → Ask user to sign in manually first
   - Confirm logged-in state before proceeding
4. `browser_snapshot` - Examine initial DOM structure
5. `browser_evaluate` - Install click listener (once per session)

### Click Listener Installation
Install this listener once at the start of exploration:

```javascript
await browser_evaluate(() => {
  if (window.advancedClickListener) return 'Listener already installed';
  window.advancedClickListener = true;
  window.lastClick = null;

  const priority = ['data-testid', 'data-test', 'data-id', 'data-lp-id', 'id'];

  document.addEventListener('click', (event) => {
    const chain = [];
    let node = event.target;
    let depth = 0;
    let bestSelector = null;

    while (node && depth < 10) {
      const attrs = Object.fromEntries(Array.from(node.attributes || []).map(a => [a.name, a.value]));
      const winner = priority.find((n) => attrs[n]);
      const css = node.id
        ? `#${CSS.escape(node.id)}`
        : winner
          ? `[${winner}="${CSS.escape(attrs[winner])}"]`
          : node.tagName.toLowerCase();

      chain.push({ tag: node.tagName, attrs, css });

      if (!bestSelector && winner) {
        bestSelector = `[${winner}="${attrs[winner]}"]`;
      }

      node = node.parentElement;
      depth += 1;
    }

    const fallback = chain.reverse().map(x => x.css).join(' > ');
    window.lastClick = {
      suggestedSelector: bestSelector || fallback,
      selectorType: bestSelector ? 'data-attribute' : 'css-path',
      hierarchy: chain
    };
  }, true);

  return 'Advanced listener installed';
});
```

After clicking, retrieve the actual target element data:
```javascript
const clickData = await browser_evaluate(() => window.lastClick);
// hierarchy[0] contains the actual clicked element (event.target)
// Check hierarchy[0].attrs for data-testid, data-id, id, etc.
```

The click listener captures `event.target` and walks up the DOM tree. The first element in `hierarchy` is what was actually clicked (which may be an icon inside a button). Check `hierarchy[0].attrs` for data attributes before using aria-labels or text from `browser_snapshot`.

**Common data-* patterns to look for:**
- `data-testid`, `data-test-id`, `data-test`
- `data-id`, `data-control-id`
- `data-lp-id` (layout/positioning hints)
- `data-automation-id`, `data-qa`, `data-cy`
- Framework-specific: `data-ng-*`, `data-bind`, `data-component`

**CRITICAL DECISION TREE - When MCP click listener returns clickData:**
1. Check `clickData.hierarchy[0].attrs['data-testid']` → Use Locator with data-testid
2. Check `clickData.hierarchy[0].attrs['data-test']` → Use Locator with data-test
3. Check `clickData.hierarchy[0].attrs['data-id']` → Use Locator with data-id
4. Check `clickData.hierarchy[0].attrs['data-lp-id']` → Use Locator with data-lp-id
5. Check `clickData.hierarchy[0].attrs['id']` → Use Locator with id attribute
6. Check `clickData.hierarchy[1].attrs` (parent) + child element type → Use scoped Locator
7. If NONE exist → Document warning about fragility and risk of duplicates

### Walk-Through for Each Step Definition

For each missing step from **bdd-planner**:

**1. Locate & Analyze DOM Structure**
- `browser_snapshot` - Find the UI element referenced in the step
- Look for: data-testid, data-test, data-id, data-lp-id, or id attributes
- Note: element tag, visible text, surrounding context

**2. Test the Selector**
- If clickable: `browser_click` then `browser_evaluate(() => window.lastClick)` to get best selector
- If fillable: `browser_snapshot` to identify input type and attributes
- If verifiable: `browser_snapshot` to see the confirmation element

**3. Verify Post-Action State**
- After interaction: `browser_snapshot` - What element appears/changes?
- What confirms the action succeeded? (success message, new page, state change)
- What should we wait for in the binding?

**4. Special Case: Dropdowns, Lookups, and Multi-Step Selections**

When a field requires opening a dialog/dropdown and selecting from a list:

a) **Initial State Discovery**
   - `browser_snapshot` - Note the trigger element (button, search icon, input field)
   - Document the selector for the trigger

b) **Open Dialog/Dropdown**
   - `browser_click` on the trigger element
   - `browser_snapshot` - Examine what appears (modal, flyout, dropdown panel)
   - Note: Panel structure, tab organization, search inputs

c) **Selection Strategy Discovery**
   - Check for **Recent/Default items** in the panel (often visible immediately)
   - Check for **Search/Filter input** (usually a textbox or searchbox)
   - Check **how items are rendered**: links, buttons, list items, options
   - `browser_snapshot` to see the item structure

d) **Implement Multi-Path Strategy**
   ```csharp
   // Pattern: Try direct selection first (if item visible), then search fallback
   try
   {
       // Option 1: Item visible in recent/default list
       var visibleItem = Page.GetByText(itemName, new() { Exact = true }).First;
       await visibleItem.WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 3000 });
       await visibleItem.ClickAsync();
   }
   catch
   {
       // Option 2: Search for item
       var searchInput = Page.GetByPlaceholder("Search...");
       await searchInput.FillAsync(itemName);
       await Task.Delay(800); // Allow search results to populate
       
       var searchResult = Page.GetByText(itemName, new() { Exact = true }).First;
       await searchResult.ClickAsync();
   }
   ```

e) **Verify Dialog Closed**
   - `browser_snapshot` after selection - Confirm dialog/dropdown closed
   - Verify selected value appears in the original field
   - Document the confirmation element for wait strategy

**4. Document Findings**
```
BINDING: [When] I [action] [parameter]
STEP FROM GHERKIN: [exact step phrase]
CONTEXT FROM PLANNER: [business description of what element does]

SELECTOR DISCOVERY:
  Primary (data attribute): [data-testid='...'] OR [data-id='...']
  Fallback (ID): [id='...']
  Risk assessment: [Unique? Duplicate risk? Localization safe?]

INTERACTION:
  Action type: [click / fill / select / etc]
  Input source: [Parameter name, DataTable column]

WAIT STRATEGY:
  Pre-action check: [Element must be visible? Enabled?]
  Post-action confirmation: [Wait for element: X with state Y]

NOTES: [Any edge cases, duplicates, or selector fragility]
```

### Element Categorization
- **Generic (REUSE existing):** App header/nav/footer, command bar buttons (New/Save/Delete), standard form controls, grid interactions
- **Feature-Specific (new):** Unique field names, custom workflows, entity-specific validations

Study existing bindings to maximize reuse before creating new ones.

### Duplicate Element Detection
During exploration, if you notice:
- Multiple records with same name in a list
- Repeated UI patterns (tabs, accordions, cards)
- Dynamic content that may repeat

Document as **DUPLICATE RISK** and plan to use:
1. Unique data attributes if available
2. Scoped selectors (parent container + child)
3. `.First` property as last resort (with explanatory comment)

### Common Selection Patterns to Discover

**Pattern: Lookup/Autocomplete Fields**
- Trigger: Search icon button, input field, or combo box
- Opens: Modal dialog, dropdown panel, or inline suggestions
- Contains: Search input + list of options/recent items
- Selection: Click on text/link/button within the panel
- Confirmation: Panel closes, value appears in field

**Pattern: Date Pickers**
- Trigger: Calendar icon or date input field
- Opens: Calendar widget/panel
- Contains: Month/year navigation, day grid
- Selection: Click on specific day cell
- Confirmation: Calendar closes, formatted date appears

**Pattern: Multi-Select Dropdowns**
- Trigger: Dropdown button or field
- Opens: Checkbox list or tag selector
- Contains: Multiple selectable items
- Selection: Click checkboxes or tags (may allow multiple)
- Confirmation: Selected items show as pills/tags in field

**Discovery Approach for All Patterns:**
1. `browser_snapshot` before interaction
2. `browser_click` to open
3. `browser_snapshot` to see what appeared
4. Identify selection mechanism (click, type, check)
5. `browser_snapshot` after selection to confirm state

## Selector & Wait Rules

### Selector Priority
Use selectors in this order:

1. **Data attributes** - MOST RESILIENT (survives localization, UI changes, duplicates)
   ```csharp
   await Page.Locator("[data-testid='submit-button']").ClickAsync();
   await Page.Locator("[data-id='sitemap-entity-subarea_29960cd8']").ClickAsync();
   ```

2. **GetByTestId** - Explicit test contract
   ```csharp
   await Page.GetByTestId("submit").ClickAsync();
   ```

3. **ID attribute** - Standard HTML identifier (must be unique)
   ```csharp
   await Page.Locator("css=[id='unique-id']").ClickAsync();
   ```

4. **Combination selectors** - Unique parent data attribute + child selector
   ```csharp
   await Page.Locator("[data-id='parent-container'] button").ClickAsync();
   await Page.Locator("[data-id='nav-group'] [role='treeitem']").First.ClickAsync();
   ```

5. **GetByRole with Name** - Accessibility-focused, but RISKY
   ```csharp
   // WARNING: Name parameter uses display text - BREAKS with localization AND duplicates
   // Only use if selector discovery found NO data-* or id attributes
   await Page.GetByRole(AriaRole.Button, new() { Name = "Save" }).ClickAsync();
   ```

6. **GetByLabel** - For form inputs with labels (if no data attributes)
   ```csharp
   // WARNING: Label text can change with localization
   await Page.GetByLabel("Password").FillAsync(password);
   ```

7. **GetByPlaceholder** - For inputs with placeholder text
   ```csharp
   // WARNING: Placeholder text can change with localization
   await Page.GetByPlaceholder("Enter name").FillAsync(value);
   ```

### FORBIDDEN - Display text for interactive elements
```csharp
// ❌ NEVER USE - breaks with localization AND creates strict mode violations
await Page.GetByText("Sign in").ClickAsync(); // FORBIDDEN
await Page.GetByRole(AriaRole.Link, new() { Name = "Product ABC" }).ClickAsync(); // Can match multiple

// ✅ CORRECT - Always use data attributes from selector discovery
await Page.Locator("[data-id='nav-item-products']").ClickAsync();

// ✅ ACCEPTABLE - GetByText ONLY for assertions/waits on non-interactive content
await Page.GetByText("Welcome message").WaitForAsync(new() { State = WaitForSelectorState.Visible });
```

### Wait Strategy Rules

**ABSOLUTELY FORBIDDEN:**
```csharp
// ❌ NEVER USE - These cause flaky tests
await Page.WaitForLoadStateAsync(LoadState.NetworkIdle); // FORBIDDEN
await Page.WaitForLoadStateAsync(LoadState.Load); // FORBIDDEN after clicks
await Task.Delay(500); // FORBIDDEN
```

**ALWAYS DO THIS:**
```csharp
// 1. MCP: browser_snapshot BEFORE action → Document available elements
// 2. MCP: browser_click/fill → Perform action
// 3. MCP: browser_snapshot AFTER action → See what appeared
// 4. CODE: Wait for that specific element from after-snapshot

// Example: After clicking navigation item
var navItem = Page.Locator("[data-id='nav-item-products']");
await navItem.WaitForAsync(new() { State = WaitForSelectorState.Visible });
await navItem.ClickAsync();
// Wait for page-specific element that appeared in MCP snapshot
await Page.GetByRole(AriaRole.Heading, new() { Name = "Active Products" })
    .WaitForAsync(new() { State = WaitForSelectorState.Visible });

// For dropdowns/lookups - MULTI-PATH PATTERN
var triggerButton = Page.Locator("[data-testid='lookup-trigger']");
await triggerButton.ClickAsync();
// Wait for panel that appeared in MCP snapshot
await Task.Delay(1000); // Brief wait for panel animation

try
{
    // Try selecting from visible options first
    var visibleOption = Page.GetByText("Option Name", new() { Exact = true }).First;
    await visibleOption.WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 3000 });
    await visibleOption.ClickAsync();
}
catch
{
    // Fallback: Use search if item not immediately visible
    var searchInput = Page.Locator("[data-testid='search-input']");
    await searchInput.FillAsync("Option Name");
    await Task.Delay(800); // Allow search results to render
    
    var searchResult = Page.GetByText("Option Name", new() { Exact = true }).First;
    await searchResult.ClickAsync();
}

// Wait for panel to close (element from after-snapshot)
await Task.Delay(500); // Brief wait for panel close animation
```

### Handling Duplicates
```csharp
// Problem: Playwright throws "strict mode violation: resolved to 2 elements"

// WORKAROUND: Use .First (but document why in comment)
// NOTE: Using .First because test may create duplicate records in test environment
await Page.GetByRole(AriaRole.Link, new() { Name = "Product ABC" }).First.ClickAsync();

// BETTER: Combine with unique parent to make selector more specific
await Page.Locator("[data-id='recent-items']")
    .GetByRole(AriaRole.Link, new() { Name = "Product ABC" }).ClickAsync();

// BEST: Use data attributes that are guaranteed unique
await Page.Locator("[data-id='product-item-12345']").ClickAsync();
```

### When to Use Task.Delay (Sparingly)

**FORBIDDEN:**
```csharp
await Task.Delay(2000); // Random delay hoping page loads
```

**ACCEPTABLE (Only These Cases):**
```csharp
// 1. Brief wait for animations (panel open/close, slide transitions)
await triggerButton.ClickAsync();
await Task.Delay(500); // Allow slide-in panel animation to complete
await Page.Locator("[data-testid='panel-content']").WaitForAsync(...);

// 2. Debounced search results (after typing in search box)
await searchInput.FillAsync("query");
await Task.Delay(800); // Search API typically debounces 300-500ms
await Page.GetByText("Result").WaitForAsync(...);

// 3. After selection in dialogs (close animation)
await optionInDialog.ClickAsync();
await Task.Delay(500); // Allow dialog close animation
// Then verify dialog is gone or value updated
```

**RULE:** Always follow `Task.Delay` with a `.WaitForAsync()` on a specific element. Never use delay as the only wait strategy.

## Step Definition Implementation

### Reqnroll Step Definition Rules

**Class Structure:**
- Must be in a `public` class marked with `[Binding]` attribute
- Must be `public` methods
- Can be static or instance methods (instance methods create new class per scenario)
- Should return `void` or `Task` (async methods must return `Task`)
- Cannot have `out`, `ref`, or optional parameters

**Attribute Types:**
- `[Given(expression)]` - Preconditions and setup
- `[When(expression)]` - Actions and events
- `[Then(expression)]` - Assertions and verification
- `[StepDefinition(expression)]` - Matches any step type

**Expression Types (Choose One):**

1. **Cucumber Expressions** (Recommended):
   ```csharp
   [Given("the user has {int} items")]
   public void GivenUserHasItems(int count) { }
   
   [When("I search for {string}")]
   public void WhenISearchFor(string term) { }
   
   [Then("the price should be ${float}")]
   public void ThenPriceShouldBe(decimal price) { }
   ```
   
   Common parameter types: `{int}`, `{float}`, `{double}`, `{string}`, `{word}`

2. **Regular Expressions** (Alternative):
   ```csharp
   [Given(@"the user has (\d+) items")]
   public void GivenUserHasItems(int count) { }
   
   [When(@"I search for ""(.*)""")]
   public void WhenISearchFor(string term) { }
   ```
   
   Capture groups `(.*)`, `(\d+)` become method parameters in order

**DataTable Parameters:**
```csharp
[When("I fill in the form with:")]
public async Task WhenIFillForm(DataTable dataTable)
{
    // Access rows
    foreach (var row in dataTable.Rows)
    {
        var field = row["Field"];
        var value = row["Value"];
    }
    
    // Or convert to strongly typed
    var items = dataTable.CreateSet<(string Product, int Quantity)>();
    foreach (var item in items)
    {
        // Use item.Product and item.Quantity
    }
}
```

**Multiple Step Definitions:**
```csharp
// Same method, multiple phrasings
[When("I perform a simple search on {string}")]
[When("I search for {string}")]
public void WhenISearch(string searchTerm) { }
```

### Template Structure
```csharp
using Microsoft.Playwright;
using Reqnroll;
using Tests.BDD.Support;

namespace Tests.BDD.StepDefinitions;

[Binding]
public class [FeatureName]Steps
{
    private readonly PageActions _pageActions;
    private IPage Page => _pageActions.Page;

    public [FeatureName]Steps(PageActions pageActions)
    {
        _pageActions = pageActions;
    }

    [Given(@"I am on the [entity] page")]
    public async Task GivenIAmOnThePage()
    {
        Console.WriteLine("Navigating to [entity] page at [URL]");
        await _pageActions.NavigateTo("[URL]");
        try
        {
            Console.WriteLine("Waiting for page heading...");
            await Page.GetByText("[Unique heading]")
                .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 30000 });
            Console.WriteLine("Page loaded successfully");
        }
        catch (TimeoutException)
        {
            Console.WriteLine("Page load timeout - checking for login prompt");
            if (await Page.GetByText("Sign in").IsVisibleAsync())
            {
                throw new InvalidOperationException("Auth state expired. Re-run headed and log in.");
            }
            throw;
        }
    }

    [When(@"I fill in the [entity] form with:")]
    public async Task WhenIFillForm(DataTable dataTable)
    {
        Console.WriteLine("Filling form with {0} fields", dataTable.Rows.Count);
        foreach (var row in dataTable.Rows)
        {
            var field = row["Field"];
            var value = row["Value"];
            Console.WriteLine("  Setting {0} = {1}", field, value);

            switch (field)
            {
                case "[Interactive Field]":
                    var picker = Page.Locator("[data-testid='field-selector']");
                    await picker.ClickAsync();
                    await Page.Locator("[data-testid='dropdown-panel']")
                        .WaitForAsync(new() { State = WaitForSelectorState.Visible });
                    await Page.Locator($"[data-id='option-{value}']").ClickAsync();
                    await Page.Locator("[data-testid='confirmation-toast']")
                        .WaitForAsync(new() { State = WaitForSelectorState.Visible });
                    break;

                case "[Text Field]":
                    await Page.Locator("[data-testid='text-field']").FillAsync(value);
                    break;
            }
        }
    }

    [Then(@"I should see ""(.*)"")]
    public async Task ThenIShouldSee(string message)
    {
        await Page.GetByText(message).WaitForAsync(new() { State = WaitForSelectorState.Visible });
        Assert.IsTrue(await _pageActions.HasText(message));
    }
}
```

### Critical Binding Rules
- Use DataTable for table parameters (Reqnroll best practice)
- All methods async/await - Return Task, never block on synchronous operations
- Observable outcomes only - Verify what user sees, not database state
- Descriptive assertions - Include failure messages for clarity
- Match existing code style - Follow the project's conventions and patterns

### Adapter Pattern (If Customer Structure Differs)
```csharp
// Adapt namespace, imports, and injected classes to match their project
using Their.Namespace;
using Their.Support;

[Binding]
public class [FeatureName]Steps
{
    private readonly IPage _page; // Or whatever they inject

    public [FeatureName]Steps([TheirContext] context)
    {
        _page = context.Page; // Adapt to their pattern
    }
    
    // Use their patterns and conventions
}
```

### Helper Method Usage
Before creating new bindings, check `PageActions.cs`:
- Does it already provide `FillAsync(field, value)`?
- Does it already provide `ClickAsync(buttonName)`?
- Does it already provide `HasText(message)`?

If yes, call the helper instead of writing Playwright code directly. This maximizes consistency and reusability.

## Selector Validation Checklist

For each selector discovered:

- [ ] **Data attribute present?** (data-testid, data-test, data-id, data-lp-id, id)
- [ ] **Unique?** No duplicates in current DOM
- [ ] **Localization-safe?** Not dependent on display text
- [ ] **Resilient to UI changes?** Not a deep CSS path
- [ ] **Documented risk?** If using `.First` or fragile CSS, add explanatory comment

If validation fails:
- Flag for **bdd-planner** to reconsider the step
- Recommend to development team to add stable data attributes
- Document the risk in code comments

## Playwright Implementation Notes

### Preferred Patterns
```csharp
// ✅ Data attributes
await Page.Locator("[data-testid='submit']").ClickAsync();
await Page.Locator("[data-id='parent'] button").ClickAsync();

// ✅ Acceptable assertions
await Page.GetByText("Record saved").WaitForAsync(new() { State = WaitForSelectorState.Visible });

// ✅ Reuse PageActions helpers
await _pageActions.ClickAsync("Save");
await _pageActions.FillAsync("Destination", "Tokyo");
```

### Anti-Patterns
```csharp
// ❌ Display text for clicks
await Page.GetByText("Sign in").ClickAsync();

// ❌ Hard waits
await Task.Delay(500);

// ❌ Network waits
await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

// ❌ Duplicate fallback without documentation
await Page.GetByRole(AriaRole.Link, new() { Name = "Product ABC" }).First.ClickAsync();
```

## Deliverables

- Step definition files (`.cs`) in `StepDefinitions/` folder
- Naming: `[FeatureName]Steps.cs` matching the `.feature` file
- Include inline comments for complex selectors
- Add verbose logging for troubleshooting (Console.WriteLine or TestContext output)
- No markdown summaries or documentation files

Run tests with:
```powershell
dotnet build
dotnet test --filter "FullyQualifiedName~YourFeatureName"
```

## Iteration Protocol

### If Selector Discovery Fails
1. Document the problem: "Button labeled 'X' has no data attributes and multiple instances exist"
2. Request guidance: Return to **bdd-planner** to refine the step
3. Alternative approaches: Consider splitting one step into multiple smaller steps, or parameterizing with unique identifiers

### If Step Is Ambiguous
1. Check existing bindings for similar patterns
2. If pattern exists, reuse it with adjusted parameters
3. If pattern doesn't exist, clarify requirements with **bdd-planner**

### If Element Behavior Is Unexpected
1. Document actual behavior vs expected (from Gherkin)
2. Take screenshots to illustrate
3. Propose step refinement to **bdd-planner**
4. Update bindings after approval

## Never Create (From This Chatmode)
- Gherkin scenarios (.feature files - bdd-planner creates these)
- .feature.cs files (auto-generated by Reqnroll during build)
- Feature file content or business-focused test scenarios
- Test runner configuration or infrastructure code
- Helper classes or utilities (reuse existing PageActions)
- Feature design documents

## Test Execution Notes
- Browser window will appear during test execution (headed mode default)
- Window stays open briefly then closes automatically after test completes
- First run may require manual login - user should see the browser window
- Subsequent runs reuse encrypted auth state automatically
- If user doesn't see browser: Check for popup blockers or window focus issues

## Handling UI Changes
- When application behavior changes: update selectors and waits
- When step vocabulary changes: collaborate with **bdd-planner** to update Gherkin and bindings together
- Re-run targeted tests after each change to confirm deterministic behaviour
