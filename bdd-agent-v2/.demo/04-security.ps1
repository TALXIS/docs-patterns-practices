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

txc workspace component create pp-solution `
    --output "src/Solutions.Security" `
    --param "PublisherName=$PublisherName" `
    --param "PublisherPrefix=$PublisherPrefix"

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

txc workspace component create pp-security-role `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse worker"

Write-Host "  ✓ Role: Warehouse worker" -ForegroundColor Green

txc workspace component create pp-security-role `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse manager"

Write-Host "  ✓ Role: Warehouse manager" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Role Privileges
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Security Role Privileges ──" -ForegroundColor Cyan

# Warehouse worker — warehouseitem: Read/Write/Create/Append/AppendTo (Global)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse worker" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ Worker → warehouseitem (RWCA)" -ForegroundColor Green

# Warehouse worker — warehouselocation: Read (Global)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse worker" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ Worker → warehouselocation (R)" -ForegroundColor Green

# Warehouse worker — warehousetransaction: Read (Global), Write (Basic)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse worker" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Basic }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehousetransaction"

Write-Host "  ✓ Worker → warehousetransaction (R/W)" -ForegroundColor Green

# Warehouse manager — warehouseitem: Full CRUD (Global)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse manager" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ Manager → warehouseitem (CRUD)" -ForegroundColor Green

# Warehouse manager — warehouselocation: Full CRUD (Global)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse manager" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ Manager → warehouselocation (CRUD)" -ForegroundColor Green

# Warehouse manager — warehousetransaction: Full CRUD (Global)
txc workspace component create pp-security-role-privilege `
    --output "src/Solutions.Security" `
    --param "RoleName=Warehouse manager" `
    --param "PrivilegeTypeAndLevel=[{ PrivilegeType: Read, Level: Global }, { PrivilegeType: Write, Level: Global }, { PrivilegeType: Create, Level: Global }, { PrivilegeType: Delete, Level: Global }, { PrivilegeType: Append, Level: Global }, { PrivilegeType: AppendTo, Level: Global }]" `
    --param "EntityLogicalName=${PublisherPrefix}_warehousetransaction"

Write-Host "  ✓ Manager → warehousetransaction (CRUD)" -ForegroundColor Green
