using System.Security.Cryptography;
using System.Text;

namespace Tests.BDD.Support;

/// <summary>
/// Provides encryption and decryption of Playwright storage state using Windows DPAPI.
/// This follows the same approach as PowerApps-TestEngine for local Windows execution.
/// </summary>
public static class StorageStateProtector
{
    private static readonly string EncryptedStatePath = Path.Combine(Path.GetTempPath(), "playwright-auth-state.encrypted");
    private static readonly string DecryptedStatePath = Path.Combine(Path.GetTempPath(), "playwright-auth-state.json");

    /// <summary>
    /// Gets the path to the decrypted storage state file (temp location for Playwright to read).
    /// </summary>
    public static string? GetStorageStatePath()
    {
        if (!File.Exists(EncryptedStatePath))
        {
            return null;
        }

        // Decrypt the state to temp location if encrypted file exists
        try
        {
            var encryptedData = File.ReadAllBytes(EncryptedStatePath);
            var decryptedData = ProtectedData.Unprotect(encryptedData, null, DataProtectionScope.CurrentUser);
            var json = Encoding.UTF8.GetString(decryptedData);
            
            File.WriteAllText(DecryptedStatePath, json);
            return DecryptedStatePath;
        }
        catch (Exception ex)
        {
            // If decryption fails (e.g., different user account), delete the corrupted file
            Console.WriteLine($"Failed to decrypt storage state: {ex.Message}");
            File.Delete(EncryptedStatePath);
            return null;
        }
    }

    /// <summary>
    /// Saves and encrypts the storage state file.
    /// </summary>
    public static void SaveStorageState()
    {
        if (!File.Exists(DecryptedStatePath))
        {
            return;
        }

        try
        {
            var json = File.ReadAllText(DecryptedStatePath);
            var jsonBytes = Encoding.UTF8.GetBytes(json);
            
            // Encrypt using Windows DPAPI (CurrentUser scope)
            var encryptedData = ProtectedData.Protect(jsonBytes, null, DataProtectionScope.CurrentUser);
            
            // Save encrypted data
            File.WriteAllBytes(EncryptedStatePath, encryptedData);
            
            // Clean up unencrypted temp file
            File.Delete(DecryptedStatePath);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to encrypt storage state: {ex.Message}");
        }
    }

    /// <summary>
    /// Clears all stored authentication state (forces re-login on next test run).
    /// </summary>
    public static void ClearStorageState()
    {
        if (File.Exists(EncryptedStatePath))
        {
            File.Delete(EncryptedStatePath);
        }
        
        if (File.Exists(DecryptedStatePath))
        {
            File.Delete(DecryptedStatePath);
        }
    }
}
