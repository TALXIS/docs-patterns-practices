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

1. **Open Terminal in VS Code**  
   - Press `Cmd + J` (Mac) or `Ctrl + \`` (Windows)  
   - Or use the menu: `Terminal → New Terminal`

2. **Start PowerShell in the terminal**

   ```bash
   pwsh
   ```

3. **Create a working directory and required folders**

   ```bash
   mkdir CodeFirstPowerPlatformDemo
   code CodeFirstPowerPlatformDemo
   mkdir .vscode
   mkdir .demo
   ```

4. **Download the code snippet file**

   ```powershell
   Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/TALXIS/docs-patterns-practices/refs/heads/master/inner-dev-loop/demo.code-snippets' -OutFile '.vscode/demo.code-snippets'
   ```

5. **Create a PowerShell script file to use during the demo**

   ```powershell
   New-Item -ItemType File -Name '.demo/DemoScriptPad.ps1'
   ```

6. **Open the script file and start typing snippets**

   ```bash
   code .demo/DemoScriptPad.ps1
   ```

   Start typing `CFA00` to insert the first snippet.

7. **Optional: Bind F5 to clear the terminal and run the script**

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

8. **Running the script**

   - Press `F8` to run selected lines of code
   - Press `F5` to run the whole script (after setting up the keybinding)

9. **Toggle the terminal**

   Use `Cmd + J` to open or close the terminal

---
