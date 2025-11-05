# Authentication Persistence

Playwright StorageState with Windows DPAPI encryption to persist authentication across test runs.

## How It Works

**First Run:**
1. Browser launches in headed mode
2. You manually sign in (supports MFA/Conditional Access)
3. Auth state (cookies, localStorage, sessionStorage) is captured and encrypted
4. Saved to `%TEMP%\playwright-auth-state.encrypted`

**Subsequent Runs:**
1. Auth state is decrypted and loaded into browser
2. Tests run without manual login
3. Auth state updated after each run

## Implementation

- **StorageStateProtector:** Windows DPAPI encryption (CurrentUser scope)
- **Hooks.cs:** Loads auth before tests, saves after tests
- **Security:** Only the Windows user who created the file can decrypt it

## Force Re-Login

```powershell
Remove-Item "$env:TEMP\playwright-auth-state.encrypted"
```

Or in code:
```csharp
StorageStateProtector.ClearStorageState();
```

## Platform Support

- **Windows:** Full support with DPAPI encryption
- **Linux/macOS:** DPAPI not available (would need alternative encryption or store unencrypted)

## Reference

Follows [PowerApps-TestEngine](https://microsoft.github.io/PowerApps-TestEngine/context/security-testengine-storage-state-deep-dive/) pattern:
- First interactive login required
- MFA/Conditional Access compatible
- OAuth/OpenID Connect compatible
- No credentials in environment variables
- Encrypted at rest with platform APIs
