# WebScraper Auto-Start Script
# Checks if server is already running before starting

$serverDir = "C:\Users\GZ060\Desktop\AI工具\Workers\WebScraper"
$port = 8765

# Check if server already responds
try {
    $r = Invoke-WebRequest -Uri "http://localhost:$port/api/health" -UseBasicParsing -TimeoutSec 3
    # Already running, do nothing
    exit 0
} catch {
    # Not running, start it
}

# Start the server silently
$proc = Start-Process -FilePath "python" -ArgumentList "$serverDir\server.py" `
    -WorkingDirectory $serverDir `
    -WindowStyle Hidden `
    -PassThru

# Wait up to 15 seconds for it to be ready
for ($i = 0; $i -lt 15; $i++) {
    Start-Sleep -Seconds 1
    try {
        $r = Invoke-WebRequest -Uri "http://localhost:$port/api/health" -UseBasicParsing -TimeoutSec 2
        break
    } catch {}
}