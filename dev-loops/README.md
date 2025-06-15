# Power Platform Project Setup Demo

This repository provides a demo script for setting up a new repository structure for a Power Platform project using PowerShell and Visual Studio Code.

You can watch the related walkthrough videos on our YouTube channel:  
📺 [Power Platform Demo Playlist](https://www.youtube.com/playlist?list=PLFCzz03beGm5cthgn7LZh4bt-d9g1G6ip)

## Prerequisites

1. **Install Visual Studio Code**  
   [Download VS Code](https://code.visualstudio.com/)

2. **Install PowerShell (macOS only)**  
   This demo uses PowerShell scripts. On macOS, install PowerShell using the following command:

   ```bash
   dotnet tool install --global PowerShell
   ```

## Setup Instructions

3. **Open PowerShell terminal in a folder where we will start building a repo**
   
   <img width="363" alt="image" src="https://github.com/user-attachments/assets/26d1b6a3-956b-4984-a3a0-59498030f4c5" />

   
> [!TIP]
> macOS: you can start PowerShell from Terminal by running `pwsh`

5. **Create a working directory and required folders**

   ```powershell
   mkdir dev-loop-demo; `
   mkdir dev-loop-demo/.vscode; `
   mkdir dev-loop-demo/.demo; `
   code -r dev-loop-demo
   ```

6. **Open PowerShell in VS Code**
   
   - Press ``Ctrl + ` ``
   - Or use the menu: `Terminal → New Terminal`
  
> [!TIP]
> macOS: `Cmd + J` shortcut + Run `pwsh` to enter PowerShell
   

7. **Download the code snippet files by running the following command**

   ```powershell
   (Invoke-RestMethod 'https://api.github.com/repos/TALXIS/docs-patterns-practices/contents/dev-loops?ref=master' | Where-Object { $_.type -eq 'file' -and $_.name -like '*.code-snippets' }) |   ForEach-Object { Invoke-WebRequest $_.download_url -OutFile ".vscode\$($_.name)" }
   ```
   
> [!WARNING]  
> GitHub API might return an error 'No server is currently available to service your request'
> In such case, wait few moments and execut the command again.

8. **Create a PowerShell script file to use during the demo and open it**

   ```powershell
   New-Item -ItemType File -Name '.demo/DemoScriptPad.ps1'; `
   code .demo/DemoScriptPad.ps1
   ```

9. **Start typing in the script file**

   Start typing `CFA` to insert the first snippet. Select the right snippet with arrows and confirm with the enter key.

10. **Optional: Bind F5 to clear the terminal and run the whole script**

   Paste the following into the terminal to create a custom keybinding:

   ```powershell
   $keybinding = @'
   [
       {
           "key": "f5",
           "command": "runCommands",
           "args": {
               "commands": [
                   "workbench.action.terminal.clear",
                   "PowerShell.Debug.Start"
               ]
           },
           "when": "editorTextFocus && editorLangId == 'powershell'"
       }
   ]
   '@

   $path = ".vscode/keybindings.json"
   if (-not (Test-Path ".vscode")) { mkdir .vscode }
   Set-Content -Path $path -Value $keybinding
   ```

11. **Running the script**

   - Press `F8` to run selected lines of code
   - Press `F5` to run the whole script (after setting up the keybinding in the previous step)