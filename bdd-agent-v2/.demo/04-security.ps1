#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║              04: Security — Solution, Roles, and Privileges                            ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates Solutions.Security with 2 roles and entity privileges.
# Expects: $PublisherName, $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Solutions.Security
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Solutions.Security ──" -ForegroundColor Cyan

dotnet new pp-solution `
    --output "src/Solutions.Security" `
    --PublisherName $PublisherName `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

Write-Host "  ✓ Solutions.Security" -ForegroundColor Green

# Add Solutions.Security to the Package Deployer project as a .NET ProjectReference
cd src/Packages.Main
dotnet add "./Packages.Main.csproj" reference "../Solutions.Security/Solutions.Security.csproj"
cd ../..

Write-Host "  ✓ ProjectReference: Security → Packages.Main" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                    Security Roles
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Security Roles ──" -ForegroundColor Cyan

dotnet new pp-security-role `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse worker" `
    --allow-scripts yes

Write-Host "  ✓ Role: Warehouse worker" -ForegroundColor Green

dotnet new pp-security-role `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse manager" `
    --allow-scripts yes

Write-Host "  ✓ Role: Warehouse manager" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Role Privileges
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Security Role Privileges ──" -ForegroundColor Cyan

# Warehouse worker — warehouseitem: Read/Write/Create/Append/AppendTo (Global)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse worker" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ Worker → warehouseitem (RWCA)" -ForegroundColor Green

# Warehouse worker — warehouselocation: Read (Global)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse worker" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }]" `
    --EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ Worker → warehouselocation (R)" -ForegroundColor Green

# Warehouse worker — warehousetransaction: Read (Global), Write (Basic)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse worker" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Basic }]" `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

Write-Host "  ✓ Worker → warehousetransaction (R/W)" -ForegroundColor Green

# Warehouse manager — warehouseitem: Full CRUD (Global)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse manager" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ Manager → warehouseitem (CRUD)" -ForegroundColor Green

# Warehouse manager — warehouselocation: Full CRUD (Global)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse manager" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ Manager → warehouselocation (CRUD)" -ForegroundColor Green

# Warehouse manager — warehousetransaction: Full CRUD (Global)
dotnet new pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --RoleName "Warehouse manager" `
    --PrivilegeTypeAndLevel "[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

Write-Host "  ✓ Manager → warehousetransaction (CRUD)" -ForegroundColor Green
