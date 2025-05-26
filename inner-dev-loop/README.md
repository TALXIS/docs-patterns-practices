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
   
   On Mac you can start PowerShell from Terminal:
   ```bash
   pwsh
   ```

4. **Create a working directory and required folders**

   ```bash
   mkdir inner-dev-loop
   mkdir inner-dev-loop/.vscode
   mkdir inner-dev-loop/.demo
   code -r inner-dev-loop
   ```

5. **Open PowerShell in VS Code**
   
   - Press ``Ctrl + ` `` (Windows) or `Cmd + J` (Mac)
   - Or use the menu: `Terminal → New Terminal`
   - Run `pwsh` to enter PowerShell
   

6. **Download the code snippet files by running the following command**

   ```powershell
   (Invoke-RestMethod 'https://api.github.com/repos/TALXIS/docs-patterns-practices/contents/inner-dev-loop?ref=master' | Where-Object { $_.type -eq 'file' -and $_.name -like '*.code-snippets' }) |   ForEach-Object { Invoke-WebRequest $_.download_url -OutFile ".vscode\$($_.name)" }
   ```

7. **Create a PowerShell script file to use during the demo**

   ```powershell
   New-Item -ItemType File -Name '.demo/DemoScriptPad.ps1'
   ```

8. **Open the script file and start typing**

   ```bash
   code .demo/DemoScriptPad.ps1
   ```


   Start typing `CFA` to insert the first snippet. Select the right snippet with arrows and confirm with the enter key.

9. **Optional: Bind F5 to clear the terminal and run the whole script**

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

10. **Running the script**

   - Press `F8` to run selected lines of code
   - Press `F5` to run the whole script (after setting up the keybinding in the previous step)


---

## Included Code Snippets

**CFA-setup.code-snippets** 

   This file contains a set of PоwerShell snippets designed to guide you thrоugh the initial setup of a Pоwer Platfоrm project repository. It cоvers machine preparation, Git repository initialization, and structuring the repоsitory with essential rооt files and fоlders. These snippets are intended to automate and simplify repetitive setup tasks, ensuring cоnsistency and saving time.

**CFB-application-creation.code-snippets** 

   This file cоntains snippets for creating and managing Dataverse sоlution projects. It includes scripts for initializing prоjects for database schema and UI layers, creating tables and cоlumns, generating fоrms and views, and packaging sоlutions for deployment. These snippets leverage .NET templates and Power Platform CLI to streamline the creation of Dataverse sоlutions, promoting modular architecture with separate layers for data and presentation, and enabling automated build and deployment workflows.

**CFC-plugin-creation.code-snippets** 

   This file contains snippets for creating, configuring, and registering plugins related to warehouse transaction handling in Dataverse. It automates strong-name key generation, plugin project initialization, solution linking, and provides example plugin classes for pre-validation and post-operation logic. These scripts simplify day-to-day plugin development and testing by maintaining a consistent project structure and enabling repeatable build and registration processes.
   
**CFD-environment-set-up.code-snippets** 

   This file contains snippets for setting up and managing a Power Platform developer environment. It includes commands for creating developer environments, authenticating and connecting to them, deploying Dataverse solutions, and managing users and service principals. Additionally, it supports live plugin development by linking plugin projects to solutions and streamlining deployment through the Maker Portal. 

**CFE-azure-devops.code-snippets**

   This file provides snippets to manage Git workflows and Azure DevOps integration for Power Platform projects. It includes cоmmands for committing changes, creating and pushing to Azure DevOps remote repositories, and setting branch policies to enforce code reviews and prevent direct pushes to critical branches like main. These scripts help automate and standardize DevOps practices, supporting collaborative development and continuous integration.

**CFF-ui-testing.code-snippets**

   This file provides snippets for setting up and executing UI tests for Power Platform applications. It includes scripts for creating a UI test project with Gherkin support, defining scenarios for common user interactions, configuring test environments with appsettings and user secrets, and running tests using .NET tools. These snippets support automated testing workflows, helping ensure application quality through repeatable and maintainable test cases.

**CFH-pipeline.code-snippets**

   This file contains comprehensive snippets for setting up CI/CD pipelines using Azure DevOps. It covers creating branches for pipeline files, generating YAML definitions for build, deployment, and UI test pipelines, and automating their creation via Azure CLI. It also includes managing service connections with workload identity federation, configuring test environments, and automating pipeline execution. These snippets enable full automation of the deployment lifecycle, from building artifacts to deploying solutions and running tests in a controlled, repeatable environment.

**CFI-PCF.code-snippets**

   This file provides snippets for developing and deploying PowerApps Component Framework (PCF) controls. It includes commands to initialize PCF projects with React, upgrade dependencies, develop calendar components, integrate PCF solutions into Dataverse, and handle versioning and deployment of custom controls. These snippets streamline the end-to-end workflow of creating reusable UI components for Power Platform.
