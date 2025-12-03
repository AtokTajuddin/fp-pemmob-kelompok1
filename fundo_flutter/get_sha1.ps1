# Get SHA-1 Debug Certificate for Firebase
# This script helps you get the SHA-1 fingerprint needed for Google Sign-In

Write-Host "🔐 Getting SHA-1 Debug Certificate for Firebase..." -ForegroundColor Cyan
Write-Host ""

# Navigate to android directory
$androidDir = "G:\fp-pemmob\fundo_flutter\android"

if (-Not (Test-Path $androidDir)) {
    Write-Host "❌ Android directory not found: $androidDir" -ForegroundColor Red
    exit 1
}

Set-Location $androidDir

Write-Host "📂 Working directory: $androidDir" -ForegroundColor Gray
Write-Host ""
Write-Host "🔨 Running gradlew signingReport..." -ForegroundColor Yellow
Write-Host "⏳ This may take a minute on first run..." -ForegroundColor Gray
Write-Host ""

# Run gradlew signingReport
.\gradlew signingReport 2>&1 | ForEach-Object {
    $line = $_.ToString()
    
    # Highlight SHA-1 lines
    if ($line -match "SHA1:") {
        Write-Host $line -ForegroundColor Green
    }
    # Highlight Variant lines
    elseif ($line -match "Variant:") {
        Write-Host ""
        Write-Host $line -ForegroundColor Cyan
    }
    # Show Store and Alias lines
    elseif ($line -match "Store:") {
        Write-Host $line -ForegroundColor Gray
    }
    elseif ($line -match "Alias:") {
        Write-Host $line -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Copy the SHA-1 value from 'Variant: debug' section above" -ForegroundColor White
Write-Host "2. Go to Firebase Console: https://console.firebase.google.com/" -ForegroundColor White
Write-Host "3. Select your project" -ForegroundColor White
Write-Host "4. Click the gear icon (⚙️) > Project settings" -ForegroundColor White
Write-Host "5. Scroll down to 'Your apps' section" -ForegroundColor White
Write-Host "6. Find your Android app" -ForegroundColor White
Write-Host "7. Click 'Add fingerprint'" -ForegroundColor White
Write-Host "8. Paste the SHA-1 value and save" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Your Google OAuth Client ID:" -ForegroundColor Cyan
Write-Host "415208406640-iqdsluhi1rq8ghu5ed85f4uehori5nej.apps.googleusercontent.com" -ForegroundColor White
Write-Host ""

# Return to original directory
Set-Location "G:\fp-pemmob\fundo_flutter"
