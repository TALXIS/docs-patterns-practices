# Authentication Persistence

This project uses **Playwright StorageState** with **Windows DPAPI encryption** to persist authentication across test runs, eliminating the need to sign in every time.

## How It Works

### First Test Run
1. Tests launch the browser and navigate to your application
2. You'll be prompted to sign in manually (supports MFA and Conditional Access)
3. After successful login, the browser's authentication state (cookies, localStorage, sessionStorage) is captured
4. The state is encrypted using Windows Data Protection API (DPAPI) and saved to:
   ```
   %TEMP%\playwright-auth-state.encrypted
   ```

### Subsequent Test Runs
1. The encrypted auth state is decrypted and loaded into the browser context
2. Tests run without requiring manual login
3. Auth state is updated after each test run

## Implementation

- **StorageStateProtector**: Encrypts/decrypts auth state using Windows DPAPI (CurrentUser scope)
- **Hooks.cs**: Loads auth state before tests, saves after tests
- **Security**: Only the Windows user who created the encrypted file can decrypt it

## Forcing Re-Login

If you need to force a fresh login (e.g., account changed, auth expired):

### Option 1: Delete via PowerShell
```powershell
Remove-Item "$env:TEMP\playwright-auth-state.encrypted" -ErrorAction SilentlyContinue
```

### Option 2: Use the helper method
```csharp
StorageStateProtector.ClearStorageState();
```

### Option 3: Manual deletion
1. Press `Win + R`
2. Type `%TEMP%`
3. Delete `playwright-auth-state.encrypted`

## Platform Support

- **Windows**: Uses Windows DPAPI for encryption (fully supported)
- **Linux/macOS**: DPAPI is not available; auth state would need to be stored unencrypted or use a different encryption mechanism

## Reference

This approach follows the same pattern as Microsoft's [PowerApps-TestEngine](https://microsoft.github.io/PowerApps-TestEngine/context/security-testengine-storage-state-deep-dive/):
- First interactive login is required
- Supports MFA and Conditional Access policies
- Works with OAuth/OpenID Connect
- Credentials are never stored in environment variables
- Encrypted at rest using platform-specific APIs
