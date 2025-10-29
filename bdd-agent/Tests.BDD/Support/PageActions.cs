using Microsoft.Playwright;

namespace Tests.BDD.Support;

/// <summary>
/// Dynamic page actions helper - no strongly typed page objects needed.
/// AI will generate locators inline in step definitions.
/// This class provides convenient wrapper methods for common Playwright actions.
/// </summary>
public class PageActions
{
    private readonly IPage _page;

    public PageActions(BrowserContext browserContext)
    {
        _page = browserContext.Page 
            ?? throw new InvalidOperationException("Page not initialized. Make sure BeforeScenario hook has run.");
    }

    #region Navigation

    public async Task NavigateTo(string url)
    {
        await _page.GotoAsync(url);
    }

    public async Task GoBack()
    {
        await _page.GoBackAsync();
    }

    public async Task GoForward()
    {
        await _page.GoForwardAsync();
    }

    public async Task Reload()
    {
        await _page.ReloadAsync();
    }

    public string CurrentUrl => _page.Url;

    #endregion

    #region Click Actions

    public async Task ClickByRole(string role, string name)
    {
        await _page.GetByRole(ToAriaRole(role), new() { Name = name }).ClickAsync();
    }

    public async Task ClickByText(string text, bool exact = false)
    {
        await _page.GetByText(text, new() { Exact = exact }).ClickAsync();
    }

    public async Task ClickByLabel(string label)
    {
        await _page.GetByLabel(label).ClickAsync();
    }

    public async Task ClickByTestId(string testId)
    {
        await _page.GetByTestId(testId).ClickAsync();
    }

    public async Task ClickByPlaceholder(string placeholder)
    {
        await _page.GetByPlaceholder(placeholder).ClickAsync();
    }

    public async Task Click(string selector)
    {
        await _page.Locator(selector).ClickAsync();
    }

    #endregion

    #region Fill/Type Actions

    public async Task FillByLabel(string label, string value)
    {
        await _page.GetByLabel(label).FillAsync(value);
    }

    public async Task FillByPlaceholder(string placeholder, string value)
    {
        await _page.GetByPlaceholder(placeholder).FillAsync(value);
    }

    public async Task FillByRole(string role, string name, string value)
    {
        await _page.GetByRole(ToAriaRole(role), new() { Name = name }).FillAsync(value);
    }

    public async Task Fill(string selector, string value)
    {
        await _page.Locator(selector).FillAsync(value);
    }

    public async Task Type(string selector, string text, int delay = 0)
    {
        await _page.Locator(selector).PressSequentiallyAsync(text, new() { Delay = delay });
    }

    public async Task Press(string selector, string key)
    {
        await _page.Locator(selector).PressAsync(key);
    }

    #endregion

    #region Select Actions

    public async Task SelectOption(string selector, string value)
    {
        await _page.Locator(selector).SelectOptionAsync(value);
    }

    public async Task Check(string selector)
    {
        await _page.Locator(selector).CheckAsync();
    }

    public async Task Uncheck(string selector)
    {
        await _page.Locator(selector).UncheckAsync();
    }

    #endregion

    #region Wait Actions

    public async Task WaitForSelector(string selector, int timeoutMs = 30000)
    {
        await _page.WaitForSelectorAsync(selector, new() { Timeout = timeoutMs });
    }

    public async Task WaitForUrl(string url, int timeoutMs = 30000)
    {
        await _page.WaitForURLAsync(url, new() { Timeout = timeoutMs });
    }

    public async Task WaitForLoadState(string state = "load")
    {
        var loadState = state.ToLower() switch
        {
            "domcontentloaded" => LoadState.DOMContentLoaded,
            "networkidle" => LoadState.NetworkIdle,
            _ => LoadState.Load
        };
        await _page.WaitForLoadStateAsync(loadState);
    }

    #endregion

    #region Assertions/Checks

    public async Task<bool> IsVisible(string selector)
    {
        return await _page.Locator(selector).IsVisibleAsync();
    }

    public async Task<bool> IsHidden(string selector)
    {
        return await _page.Locator(selector).IsHiddenAsync();
    }

    public async Task<bool> IsEnabled(string selector)
    {
        return await _page.Locator(selector).IsEnabledAsync();
    }

    public async Task<bool> IsChecked(string selector)
    {
        return await _page.Locator(selector).IsCheckedAsync();
    }

    public async Task<string> GetText(string selector)
    {
        return await _page.Locator(selector).TextContentAsync() ?? "";
    }

    public async Task<string> GetInnerText(string selector)
    {
        return await _page.Locator(selector).InnerTextAsync();
    }

    public async Task<string?> GetAttribute(string selector, string attributeName)
    {
        return await _page.Locator(selector).GetAttributeAsync(attributeName);
    }

    public async Task<int> GetElementCount(string selector)
    {
        return await _page.Locator(selector).CountAsync();
    }

    public async Task<bool> HasText(string text, bool exact = false)
    {
        var locator = _page.GetByText(text, new() { Exact = exact });
        return await locator.CountAsync() > 0;
    }

    public async Task<bool> HasTextInElement(string selector, string text)
    {
        var content = await GetText(selector);
        return content.Contains(text);
    }

    #endregion

    #region Utility Actions

    public async Task Hover(string selector)
    {
        await _page.Locator(selector).HoverAsync();
    }

    public async Task Focus(string selector)
    {
        await _page.Locator(selector).FocusAsync();
    }

    public async Task ScrollIntoView(string selector)
    {
        await _page.Locator(selector).ScrollIntoViewIfNeededAsync();
    }

    public async Task TakeScreenshot(string path)
    {
        await _page.ScreenshotAsync(new() { Path = path, FullPage = true });
    }

    public async Task<byte[]> TakeScreenshotBytes()
    {
        return await _page.ScreenshotAsync(new() { FullPage = true });
    }

    #endregion

    #region Direct Page Access

    /// <summary>
    /// Get direct access to the IPage for advanced scenarios.
    /// Use this when PageActions doesn't provide the method you need.
    /// </summary>
    public IPage Page => _page;

    #endregion

    #region Helper Methods

    private static AriaRole ToAriaRole(string role)
    {
        return role.ToLower() switch
        {
            "alert" => AriaRole.Alert,
            "alertdialog" => AriaRole.Alertdialog,
            "application" => AriaRole.Application,
            "article" => AriaRole.Article,
            "banner" => AriaRole.Banner,
            "blockquote" => AriaRole.Blockquote,
            "button" => AriaRole.Button,
            "caption" => AriaRole.Caption,
            "cell" => AriaRole.Cell,
            "checkbox" => AriaRole.Checkbox,
            "code" => AriaRole.Code,
            "columnheader" => AriaRole.Columnheader,
            "combobox" => AriaRole.Combobox,
            "complementary" => AriaRole.Complementary,
            "contentinfo" => AriaRole.Contentinfo,
            "definition" => AriaRole.Definition,
            "deletion" => AriaRole.Deletion,
            "dialog" => AriaRole.Dialog,
            "directory" => AriaRole.Directory,
            "document" => AriaRole.Document,
            "emphasis" => AriaRole.Emphasis,
            "feed" => AriaRole.Feed,
            "figure" => AriaRole.Figure,
            "form" => AriaRole.Form,
            "generic" => AriaRole.Generic,
            "grid" => AriaRole.Grid,
            "gridcell" => AriaRole.Gridcell,
            "group" => AriaRole.Group,
            "heading" => AriaRole.Heading,
            "img" => AriaRole.Img,
            "insertion" => AriaRole.Insertion,
            "link" => AriaRole.Link,
            "list" => AriaRole.List,
            "listbox" => AriaRole.Listbox,
            "listitem" => AriaRole.Listitem,
            "log" => AriaRole.Log,
            "main" => AriaRole.Main,
            "marquee" => AriaRole.Marquee,
            "math" => AriaRole.Math,
            "meter" => AriaRole.Meter,
            "menu" => AriaRole.Menu,
            "menubar" => AriaRole.Menubar,
            "menuitem" => AriaRole.Menuitem,
            "menuitemcheckbox" => AriaRole.Menuitemcheckbox,
            "menuitemradio" => AriaRole.Menuitemradio,
            "navigation" => AriaRole.Navigation,
            "none" => AriaRole.None,
            "note" => AriaRole.Note,
            "option" => AriaRole.Option,
            "paragraph" => AriaRole.Paragraph,
            "presentation" => AriaRole.Presentation,
            "progressbar" => AriaRole.Progressbar,
            "radio" => AriaRole.Radio,
            "radiogroup" => AriaRole.Radiogroup,
            "region" => AriaRole.Region,
            "row" => AriaRole.Row,
            "rowgroup" => AriaRole.Rowgroup,
            "rowheader" => AriaRole.Rowheader,
            "scrollbar" => AriaRole.Scrollbar,
            "search" => AriaRole.Search,
            "searchbox" => AriaRole.Searchbox,
            "separator" => AriaRole.Separator,
            "slider" => AriaRole.Slider,
            "spinbutton" => AriaRole.Spinbutton,
            "status" => AriaRole.Status,
            "strong" => AriaRole.Strong,
            "subscript" => AriaRole.Subscript,
            "superscript" => AriaRole.Superscript,
            "switch" => AriaRole.Switch,
            "tab" => AriaRole.Tab,
            "table" => AriaRole.Table,
            "tablist" => AriaRole.Tablist,
            "tabpanel" => AriaRole.Tabpanel,
            "term" => AriaRole.Term,
            "textbox" => AriaRole.Textbox,
            "time" => AriaRole.Time,
            "timer" => AriaRole.Timer,
            "toolbar" => AriaRole.Toolbar,
            "tooltip" => AriaRole.Tooltip,
            "tree" => AriaRole.Tree,
            "treegrid" => AriaRole.Treegrid,
            "treeitem" => AriaRole.Treeitem,
            _ => throw new ArgumentException($"Unknown ARIA role: {role}")
        };
    }

    #endregion
}
