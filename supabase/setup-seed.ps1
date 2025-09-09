# Supabase Seed Data Setup Script
# This script helps you replace the placeholder UUID in seed.sql with your actual user UUID

param(
    [Parameter(Mandatory=$true)]
    [string]$UserUUID,
    
    [Parameter(Mandatory=$false)]
    [string]$Email = "your-email@example.com",
    
    [Parameter(Mandatory=$false)]
    [string]$FullName = "Your Full Name"
)

Write-Host "🚀 Setting up Supabase seed data..." -ForegroundColor Cyan
Write-Host ""

# Validate UUID format
$uuidPattern = '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
if ($UserUUID -notmatch $uuidPattern) {
    Write-Host "❌ Error: Invalid UUID format!" -ForegroundColor Red
    Write-Host "   Expected format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ForegroundColor Yellow
    Write-Host "   Example: a1b2c3d4-e5f6-7890-abcd-ef1234567890" -ForegroundColor Yellow
    exit 1
}

$seedFile = ".\seed.sql"

if (!(Test-Path $seedFile)) {
    Write-Host "❌ Error: seed.sql not found in current directory!" -ForegroundColor Red
    Write-Host "   Make sure you're running this script from the supabase folder." -ForegroundColor Yellow
    exit 1
}

Write-Host "📝 Updating seed.sql with your information:" -ForegroundColor Green
Write-Host "   UUID: $UserUUID" -ForegroundColor White
Write-Host "   Email: $Email" -ForegroundColor White  
Write-Host "   Name: $FullName" -ForegroundColor White
Write-Host ""

try {
    # Read the file content
    $content = Get-Content $seedFile -Raw
    
    # Replace placeholder UUID
    $content = $content -replace 'YOUR_USER_UUID_HERE', $UserUUID
    
    # Replace placeholder email and name
    $content = $content -replace 'your-email@example\.com', $Email
    $content = $content -replace 'Your Full Name', $FullName
    
    # Write back to file
    Set-Content $seedFile $content -Encoding UTF8
    
    Write-Host "✅ Successfully updated seed.sql!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Copy the content of seed.sql" -ForegroundColor White
    Write-Host "2. Paste and run it in your Supabase SQL Editor" -ForegroundColor White
    Write-Host "3. Test your app login with:" -ForegroundColor White
    Write-Host "   Email: $Email" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎉 Setup complete!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error updating seed.sql: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Usage examples
Write-Host ""
Write-Host "💡 Usage examples:" -ForegroundColor Cyan
Write-Host '   .\setup-seed.ps1 -UserUUID "a1b2c3d4-e5f6-7890-abcd-ef1234567890"' -ForegroundColor Gray
Write-Host '   .\setup-seed.ps1 -UserUUID "a1b2c3d4-e5f6-7890-abcd-ef1234567890" -Email "admin@mycompany.com" -FullName "John Doe"' -ForegroundColor Gray
