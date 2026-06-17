# Siya Charts - Local Web Server in PowerShell
# Hosts the static site on http://localhost:8000 with clean URL support.

$port = 8000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host " Siya Charts Local Web Server is Running!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host "👉 Open your browser and go to: http://localhost:$port/" -ForegroundColor Cyan
Write-Host "👉 To stop the server, press Ctrl + C in this terminal window."
Write-Host "=================================================="
Write-Host ""

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $urlPath = $request.Url.LocalPath
        
        # Resolve files correctly
        if ($urlPath -eq "/") {
            $filePath = Join-Path $PSScriptRoot "index.html"
        } else {
            # Replace forward slashes with backslashes for Windows path matching
            $cleanPath = $urlPath.Replace("/", "\").TrimStart('\')
            $filePath = Join-Path $PSScriptRoot $cleanPath
            
            # If path points to a directory, load its index.html (Clean URLs support)
            if (Test-Path $filePath -PathType Container) {
                $filePath = Join-Path $filePath "index.html"
            }
        }
        
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            
            # Set Content-Type header
            if ($filePath.EndsWith(".html")) {
                $response.ContentType = "text/html; charset=utf-8"
            } elseif ($filePath.EndsWith(".css")) {
                $response.ContentType = "text/css"
            } elseif ($filePath.EndsWith(".js")) {
                $response.ContentType = "application/javascript"
            } elseif ($filePath.EndsWith(".json")) {
                $response.ContentType = "application/json"
            } elseif ($filePath.EndsWith(".xml")) {
                $response.ContentType = "application/xml"
            } elseif ($filePath.EndsWith(".txt")) {
                $response.ContentType = "text/plain"
            }
            
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            # 404 Page Not Found
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("<h1>404 Not Found</h1><p>File $urlPath does not exist.</p>")
            $response.ContentType = "text/html"
            $response.ContentLength64 = $errBytes.Length
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }
        $response.Close()
    }
} catch {
    Write-Host "Server stopped."
} finally {
    $listener.Stop()
}
