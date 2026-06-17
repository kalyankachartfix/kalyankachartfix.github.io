# Kalyan Ka Chart Fix - Static Site Builder compiler in PowerShell
# Natively compiles the site on Windows without external dependencies.

$srcDir = Join-Path $PSScriptRoot "src"
$dataDir = Join-Path $srcDir "data"
$outDir = $PSScriptRoot

# Create assets output dirs
$cssOutDir = Join-Path $outDir "assets\css"
$jsOutDir = Join-Path $outDir "assets\js"
if (!(Test-Path $cssOutDir)) { New-Item -ItemType Directory -Force -Path $cssOutDir }
if (!(Test-Path $jsOutDir)) { New-Item -ItemType Directory -Force -Path $jsOutDir }

# ----------------- CONSTANTS & CONTENT -----------------

$domain = "https://kalyankachartfix.github.io"
$lastUpdated = "2026-06-17"

$markets = @(
    @{
        id = "kalyan-chart"
        name = "Kalyan Chart"
        title = "Kalyan Chart - Live Kalyan Matka Jodi Chart Record Book 2026"
        desc = "Get the fastest Kalyan Chart, Kalyan Matka Jodi Record Book, Kalyan historical panel chart results. Super fast updates, red jodis, and mobile-friendly Kalyan chart online."
        intro = "Welcome to kalyankachartfix.github.io, the most trusted and updated platform for Kalyan Chart historical records. The Kalyan market is one of the most prominent Satta Matka games in India, commanding a huge player base. Our Jodi chart offers day-by-day and week-by-week results tracking. Analyzing the Kalyan Jodi record is crucial for enthusiasts aiming to formulate patterns and guess the next winning numbers. By reviewing Red Jodis (doubles and cut numbers) and panel trends, players can identify repeat sequences. Our Kalyan chart updates dynamically in real-time as soon as the results are declared. Bookmark this page for the fastest Kalyan results!"
        faqs = @(
            @{ q = "What is the Kalyan Chart?"; a = "The Kalyan Chart is a tabular representation of historical Satta Matka results for the Kalyan market. It shows the daily 2-digit Jodi numbers grouped by weeks, helping players analyze past results." },
            @{ q = "When are the Kalyan Chart results updated?"; a = "Kalyan results are updated twice daily. The Open result is declared at 03:45 PM, and the Close result is declared at 05:45 PM. The combined Jodi is updated immediately after the close result." },
            @{ q = "What is a Red Jodi in Kalyan Matka?"; a = "A Red Jodi occurs when both digits are identical (e.g., 22, 77) or when the two digits are 'cuts' of each other, meaning they differ by 5 (e.g., 16, 27, 38, 49, 05). These are highlighted in red to assist in pattern analysis." }
        )
    },
    @{
        id = "kalyan-night-chart"
        name = "Kalyan Night Chart"
        title = "Kalyan Night Chart - Live Kalyan Night Matka Records"
        desc = "Access the Kalyan Night Chart with historical records, fast result updates, and download features. Check out your Kalyan Night results on a clean, responsive table."
        intro = "Welcome to the ultimate Kalyan Night Chart portal on kalyankachartfix.github.io. The Kalyan Night draw provides a comprehensive log of the nightly Kalyan Matka draw. This chart is essential for night-game enthusiasts who follow the evening draw patterns. Kalyan Night is famous for its volatile patterns, making historical analysis indispensable. This page offers complete weekly data, allowing players to filter records by year and download data directly. Our table highlights red jodis to help you spot key trends. Keep up with the latest outcomes here."
        faqs = @(
            @{ q = "What are the timings for Kalyan Night Matka?"; a = "Kalyan Night Open timing is 09:25 PM, and the Close timing is 11:30 PM. Results are updated on our chart immediately after each draw." },
            @{ q = "Why is the Kalyan Night Chart important?"; a = "Analyzing the night chart helps players understand trends specific to the evening environment, which can differ significantly from day-draw patterns." }
        )
    },
    @{
        id = "kalyan-jodi-chart"
        name = "Kalyan Jodi Chart"
        title = "Kalyan Jodi Chart - Kalyan Matka Jodi Records"
        desc = "Access the Kalyan Jodi Chart with daily updates. Study historical patterns, filter results by year, and download Kalyan Jodi records."
        intro = "Get the most accurate Kalyan Jodi Chart log book on kalyankachartfix.github.io. This chart displays all the final 2-digit jodi numbers for the Kalyan market from Monday to Saturday. Analyzing the Kalyan jodi records is essential for enthusiasts who study repeating sequences, double digits, and cut numbers. Our database is updated in real-time as soon as the results are finalized. Press the Refresh button below to get the newest Kalyan Jodi numbers."
        faqs = @(
            @{ q = "What is the difference between Kalyan Chart and Kalyan Jodi Chart?"; a = "Both charts track the Kalyan market jodis. The Kalyan Chart serves as the homepage record, while this dedicated Kalyan Jodi Chart page targets specific jodi search queries." },
            @{ q = "Are the results on Kalyan Jodi Chart reliable?"; a = "Yes, our results are fetched directly from the official draw center and updated instantly, ensuring 100% accuracy." }
        )
    },
    @{
        id = "kalyan-morning-chart"
        name = "Kalyan Morning Chart"
        title = "Kalyan Morning Chart - Kalyan Morning Matka Record Book"
        desc = "View the Kalyan Morning Chart at kalyankachartfix.github.io. Kalyan Morning is the first major draw in the Kalyan category, starting off the daytime gaming session."
        intro = "View the official Kalyan Morning Chart at kalyankachartfix.github.io. Kalyan Morning is the first major draw in the Kalyan category, starting off the daytime gaming session. Checking the morning chart helps guessers identify early daily trends and digit combinations. Our table features year filters, copy options, and Excel downloads. Click the Refresh button below to pull the latest Kalyan Morning draw results."
        faqs = @(
            @{ q = "What are the draw timings for Kalyan Morning?"; a = "Kalyan Morning Open result is declared at 11:00 AM, and the Close result is declared at 12:00 PM." },
            @{ q = "Is Kalyan Morning open on Saturdays?"; a = "Yes, Kalyan Morning runs six days a week, from Monday to Saturday, and remains closed on Sundays." }
        )
    },
    @{
        id = "madhur-night-chart"
        name = "Madhur Night Chart"
        title = "Madhur Night Chart - Madhur Night Matka Records"
        desc = "Get the accurate Madhur Night Chart with historical records. Updated daily with red jodi indicators, year filtering, and export capabilities."
        intro = "Access the Madhur Night Chart for up-to-date and historical records of the popular Madhur Night market on kalyankachartfix.github.io. Analytical players rely on these historical charts to formulate logical predictions. Our website renders the Madhur Night chart statically to load fast on all networks. You can easily view year-wise records, copy the chart, print, or download in Excel format. Check out the latest records below."
        faqs = @(
            @{ q = "When is Madhur Night result declared?"; a = "Madhur Night results are declared daily, with the Open result at 08:30 PM and the Close result at 10:30 PM." },
            @{ q = "Does Madhur Night run on weekends?"; a = "Yes, Madhur Night is active from Monday to Saturday, and remains closed on Sundays." }
        )
    },
    @{
        id = "milan-night-chart"
        name = "Milan Night Chart"
        title = "Milan Night Chart - Milan Night Matka Records"
        desc = "Browse the Milan Night Chart. High speed updates, mobile-responsive tables, year filters, and offline Excel exports."
        intro = "Welcome to the Milan Night Chart directory on kalyankachartfix.github.io. The Milan Night market is a classical evening Matka game with a very loyal base of analytical players. Studying the historical Milan Night jodi records assists players in recognizing digit behavior and formulating guesses. Our table highlights double numbers and cut numbers for easy charting. Click the Refresh button below to load the latest Milan Night results."
        faqs = @(
            @{ q = "What are the draw timings for Milan Night?"; a = "Milan Night Open results are published at 09:00 PM and the Close results at 11:00 PM." },
            @{ q = "How do I filter Milan Night records?"; a = "Simply select the desired year from the dropdown above the table to show only the records for that specific year." }
        )
    },
    @{
        id = "milan-day-chart"
        name = "Milan Day Chart"
        title = "Milan Day Chart - Milan Day Matka Record Book"
        desc = "Track the Milan Day Chart for daily afternoon results. View historical jodi data, export to Excel, and filter by year."
        intro = "Browse the updated Milan Day Chart daily at kalyankachartfix.github.io. Milan Day is a premier daytime market operating six days a week. Tracking the Milan Day results helps players keep up with afternoon digit trends and find patterns in the jodi output. Enjoy our optimized and fast-loading charts on any network. Press the Refresh button below to see the latest Milan Day results."
        faqs = @(
            @{ q = "What are Milan Day timings?"; a = "Milan Day Open result is announced at 03:00 PM and the Close result is announced at 05:00 PM." },
            @{ q = "Is Milan Day open on Sunday?"; a = "No. Milan Day runs six days a week, from Monday to Saturday, and remains closed on Sundays." }
        )
    },
    @{
        id = "sridevi-chart"
        name = "Sridevi Chart"
        title = "Sridevi Chart - Sridevi Matka Record Book"
        desc = "Check the Sridevi Chart with daily morning results. Explore historical records, filter by year, and download the data."
        intro = "Get the earliest daily results with the Sridevi Chart on kalyankachartfix.github.io. Sridevi Matka is a major morning market operating all seven days of the week. Reviewing Sridevi records provides a great starting point for daytime digit analysis. Our chart features easy navigation, year filtering, and table export buttons. Click the Refresh button below to load the latest Sridevi results."
        faqs = @(
            @{ q = "What are Sridevi Matka timings?"; a = "Sridevi Open result is published at 11:35 AM and the Close result at 12:35 PM." },
            @{ q = "Does Sridevi run on Sundays?"; a = "Yes. Sridevi is one of the few markets that operates all seven days of the week, Monday to Sunday." }
        )
    }
)

# ----------------- HELPER FUNCTIONS -----------------

# Helper to check if a Jodi is "Red" (Double digits or Cut digits)
function Is-RedJodi($jodi) {
    if ($jodi -eq "XX" -or $jodi -eq "--" -or $jodi.Length -ne 2) {
        return $false
    }
    $d1 = [int][string]$jodi[0]
    $d2 = [int][string]$jodi[1]
    
    # Double check (same numbers)
    if ($d1 -eq $d2) { return $true }
    
    # Cut check (difference of 5)
    if ([Math]::Abs($d1 - $d2) -eq 5) { return $true }
    
    return $false
}

# Minify CSS using regex (strips comments, spaces, newlines)
function Minify-CSS($css) {
    # Remove comments
    $css = [regex]::Replace($css, "/\*[\s\S]*?\*/", "")
    # Remove extra spaces around braces, colons, semi-colons
    $css = [regex]::Replace($css, "\s*([\{\}:;,])\s*", '$1')
    # Replace multiple whitespaces with single space
    $css = [regex]::Replace($css, "\s+", " ")
    return $css.Trim()
}

# Minify JS using regex
function Minify-JS($js) {
    # Remove single line comments
    $js = [regex]::Replace($js, "(?<!:)\/\/.*", "")
    # Remove multi-line comments
    $js = [regex]::Replace($js, "/\*[\s\S]*?\*/", "")
    # Replace multiple spaces/newlines
    $js = [regex]::Replace($js, "\s+", " ")
    return $js.Trim()
}

# ----------------- BUILD ASSETS -----------------

Write-Host "Minifying assets..."
$cssSrc = Get-Content -Path (Join-Path $srcDir "assets\css\style.css") -Raw
$minCss = Minify-CSS $cssSrc
Set-Content -Path (Join-Path $cssOutDir "style.min.css") -Value $minCss -Encoding utf8

$jsSrc = Get-Content -Path (Join-Path $srcDir "assets\js\main.js") -Raw
$minJs = Minify-JS $jsSrc
Set-Content -Path (Join-Path $jsOutDir "main.min.js") -Value $minJs -Encoding utf8

# ----------------- TEMPLATES -----------------

# Common Logo SVG
$logoSvg = @"
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" style="vertical-align: middle; margin-right: 8px; flex-shrink: 0;">
  <circle cx="16" cy="16" r="14" fill="url(#logo-grad)" />
  <rect x="9" y="9" width="14" height="14" rx="2" stroke="white" stroke-width="1.5" />
  <line x1="9" y1="14" x2="23" y2="14" stroke="white" stroke-width="1" />
  <line x1="9" y1="18" x2="23" y2="18" stroke="white" stroke-width="1" />
  <line x1="14" y1="9" x2="14" y2="23" stroke="white" stroke-width="1" />
  <line x1="18" y1="9" x2="18" y2="23" stroke="white" stroke-width="1" />
  <path d="M11 19L14 15L17 17L21 12" stroke="#14B8A6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
  <polygon points="21 12 18 12 21 15" fill="#14B8A6" />
  <defs>
    <linearGradient id="logo-grad" x1="2" y1="2" x2="30" y2="30" gradientUnits="userSpaceOnUse">
      <stop stop-color="#6366F1" />
      <stop offset="1" stop-color="#A855F7" />
    </linearGradient>
  </defs>
</svg>
"@

# Common Navigation Header
$headerHtml = @"
  <header>
    <div class="container header-container">
      <div class="logo">
        <a href="/" style="display: flex; align-items: center;">
          $logoSvg
          <span style="font-family: var(--font-heading); font-size: 1.6rem; font-weight: 800; background: var(--primary-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">KCFIX</span>
        </a>
      </div>
      <button class="mobile-menu-btn" id="mobile-menu-btn" aria-label="Toggle menu">
        <svg viewBox="0 0 24 24"><path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/></svg>
      </button>
      <nav class="nav-links">
        <a href="/">Kalyan Chart</a>
        <a href="/kalyan-night-chart/">Kalyan Night</a>
        <a href="/kalyan-morning-chart/">Kalyan Morning</a>
        <a href="/milan-day-chart/">Milan Day</a>
        <a href="/milan-night-chart/">Milan Night</a>
      </nav>
      <div class="header-actions">
        <button class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle theme" title="Switch Theme"></button>
      </div>
    </div>
  </header>
"@

# Common Footer
$footerHtml = @"
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-col">
          <div class="footer-logo" style="display: flex; align-items: center; font-family: var(--font-heading); font-size: 1.6rem; font-weight: 800; background: var(--primary-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin-bottom: 1rem;">
            $logoSvg
            <span>KCFIX</span>
          </div>
          <p style="margin-top: 0.5rem; color: var(--text-secondary); max-width: 250px;">
            The most reliable Satta Matka records directory online. Get instant result updates and analysis tools.
          </p>
        </div>
        <div class="footer-col">
          <h4>Popular Charts</h4>
          <ul class="footer-links">
            <li><a href="/">Kalyan Chart</a></li>
            <li><a href="/kalyan-night-chart/">Kalyan Night Chart</a></li>
            <li><a href="/kalyan-jodi-chart/">Kalyan Jodi Chart</a></li>
            <li><a href="/kalyan-morning-chart/">Kalyan Morning Chart</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Other Charts</h4>
          <ul class="footer-links">
            <li><a href="/madhur-night-chart/">Madhur Night Chart</a></li>
            <li><a href="/milan-night-chart/">Milan Night Chart</a></li>
            <li><a href="/milan-day-chart/">Milan Day Chart</a></li>
            <li><a href="/sridevi-chart/">Sridevi Chart</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Info Links</h4>
          <ul class="footer-links">
            <li><a href="/">Privacy Policy</a></li>
            <li><a href="/">Terms of Service</a></li>
            <li><a href="/">Disclaimer</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 Kalyan Ka Chart Fix. Created only for informational and historical chart reference purposes.</p>
      </div>
    </div>
  </footer>
"@

# Common Disclaimer
$disclaimerHtml = @"
    <div class="disclaimer-banner">
      <strong>Disclaimer:</strong> इस लेख को लिखने का उद्देश्य सिर्फ सट्टा मटका के बारे में जानकारी प्रदान करना है हम किसी भी तरह से सट्टा मटका या ऐसे किसी भी गेम जो क़ानूनी रूप से प्रतिबंधित है उसका समर्थन नहीं करते है और न ही ऐसे खेल खेलने की आपको सलाह देते है हमने सट्टा मटका से सम्बंधित सारी जानकारी इन्टरनेट से निकाली है साथ ही वेबसाइट पर दिखाए गए किसी भी मटके के रिजल्ट की प्रमाणिकता की जिम्मेदारी हमारी नहीं है.
    </div>
"@

# Refresh Button Template
$refreshBtnHtml = @"
  <button class="btn-action btn-refresh" onclick="window.location.reload();" style="background: var(--accent-gradient); color: white; border: none; font-weight: 600; box-shadow: var(--shadow-sm); cursor: pointer; transition: transform var(--transition-fast);" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'">
    <svg viewBox="0 0 24 24" style="width: 14px; height: 14px; fill: currentColor; margin-right: 4px; vertical-align: middle;"><path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>
    REFRESH RESULTS
  </button>
"@

# ----------------- FUNCTION TO BUILD TABLE HTML -----------------

function Get-TableHtml($jsonData, [ref]$yearOptionsHtmlOut) {
    $tableRowsHtml = ""
    $yearsSet = @{}
    
    foreach ($row in $jsonData) {
        $year = $row.weekStart.Split("-")[2]
        $yearsSet[$year] = $true
        
        $monClass = if (Is-RedJodi $row.mon) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $tueClass = if (Is-RedJodi $row.tue) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $wedClass = if (Is-RedJodi $row.wed) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $thuClass = if (Is-RedJodi $row.thu) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $friClass = if (Is-RedJodi $row.fri) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $satClass = if (Is-RedJodi $row.sat) { "jodi-cell red-jodi" } else { "jodi-cell" }
        $sunClass = if (Is-RedJodi $row.sun) { "jodi-cell red-jodi" } else { "jodi-cell" }
        
        $tableRowsHtml += @"
          <tr data-week="$($row.weekStart)" data-year="$year">
            <td class="$monClass">$($row.mon)</td>
            <td class="$tueClass">$($row.tue)</td>
            <td class="$wedClass">$($row.wed)</td>
            <td class="$thuClass">$($row.thu)</td>
            <td class="$friClass">$($row.fri)</td>
            <td class="$satClass">$($row.sat)</td>
            <td class="$sunClass">$($row.sun)</td>
          </tr>
"@
    }
    
    $yearsArray = $yearsSet.Keys | Sort-Object -Descending
    $yearOptionsHtml = "<option value=`"all`">All Years</option>"
    foreach ($y in $yearsArray) {
        $yearOptionsHtml += "<option value=`"$y`">$y Records</option>"
    }
    $yearOptionsHtmlOut.Value = $yearOptionsHtml
    
    $fullTableHtml = @"
        <div class="chart-table-container">
          <table class="chart-table">
            <thead>
              <tr>
                <th>Mon</th>
                <th>Tue</th>
                <th>Wed</th>
                <th>Thu</th>
                <th>Fri</th>
                <th>Sat</th>
                <th>Sun</th>
              </tr>
            </thead>
            <tbody>
              $tableRowsHtml
            </tbody>
          </table>
        </div>
"@
    return $fullTableHtml
}

# ----------------- BUILD HOMEPAGE (index.html) -----------------
# The homepage contains the Kalyan Chart directly.

Write-Host "Building Homepage (index.html)..."

$kalyanJsonPath = Join-Path $dataDir "kalyan-chart.json"
$kalyanJsonData = Get-Content -Path $kalyanJsonPath -Raw | ConvertFrom-Json
$yearOptionsHtmlHome = ""
$kalyanTableHtml = Get-TableHtml -jsonData $kalyanJsonData -yearOptionsHtmlOut ([ref]$yearOptionsHtmlHome)

$homeRecentResults = @(
    @{ name = "Kalyan Morning"; time = "11:00 AM - 12:00 PM"; res = "128-11-236" },
    @{ name = "Sridevi"; time = "11:35 AM - 12:35 PM"; res = "138-29-234" },
    @{ name = "Milan Day"; time = "03:00 PM - 05:00 PM"; res = "358-69-135" },
    @{ name = "Kalyan"; time = "03:45 PM - 05:45 PM"; res = "139-38-350" },
    @{ name = "Madhur Night"; time = "08:30 PM - 10:30 PM"; res = "148-35-159" },
    @{ name = "Milan Night"; time = "09:00 PM - 11:00 PM"; res = "240-62-390" },
    @{ name = "Kalyan Night"; time = "09:25 PM - 11:30 PM"; res = "125-80-280" }
)

$recentCardsHtml = ""
foreach ($res in $homeRecentResults) {
    $parts = $res.res.Split("-")
    $recentCardsHtml += @"
        <div class="result-card">
          <h3>$($res.name)</h3>
          <div class="market-time">$($res.time)</div>
          <div class="result-numbers">
            <span class="panel">$($parts[0])</span>
            <span class="jodi">$($parts[1])</span>
            <span class="panel right">$($parts[2])</span>
          </div>
          <div class="update-status">Live</div>
        </div>
"@
}

$marketLinksHtml = ""
foreach ($m in $markets) {
    $marketLinksHtml += @"
        <a href="/$($m.id)/" class="market-link-card">
          <span>$($m.name)</span>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
        </a>
"@
}

# FAQs for home page
$homeFaqsHtml = @"
        <div class="faq-list">
          <div class="faq-item">
            <button class="faq-question">
              What is the Kalyan Chart?
              <svg viewBox="0 0 24 24"><path d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/></svg>
            </button>
            <div class="faq-answer">
              <p>The Kalyan Chart is a historical record log book of Satta Matka draw results for the Kalyan market. It presents the daily opening and closing Jodi numbers arranged week-by-week.</p>
            </div>
          </div>
          <div class="faq-item">
            <button class="faq-question">
              How often are results updated?
              <svg viewBox="0 0 24 24"><path d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/></svg>
            </button>
            <div class="faq-answer">
              <p>Results on Kalyan Ka Chart Fix are updated in real-time. The Kalyan draw open result is published at 03:45 PM and the close result at 05:45 PM daily except Sundays.</p>
            </div>
          </div>
          <div class="faq-item">
            <button class="faq-question">
              What is a Red Jodi?
              <svg viewBox="0 0 24 24"><path d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/></svg>
            </button>
            <div class="faq-answer">
              <p>A Red Jodi is either a double digit (e.g. 55) or a cut jodi (where the two digits differ by 5, e.g. 16, 27). These are highlighted in red to assist guessers in mathematical analysis.</p>
            </div>
          </div>
        </div>
"@

$homeOrgSchema = @{
    "@context" = "https://schema.org"
    "@type" = "Organization"
    "name" = "Kalyan Ka Chart Fix"
    "url" = "$domain/"
    "logo" = "$domain/assets/images/logo.png"
    "description" = "Instant live results and historical records directory for Kalyan Satta Matka markets."
} | ConvertTo-Json -Depth 5

$homeFaqSchema = @{
    "@context" = "https://schema.org"
    "@type" = "FAQPage"
    "mainEntity" = @(
        @{
            "@type" = "Question"
            "name" = "What is the Kalyan Chart?"
            "acceptedAnswer" = @{ "@type" = "Answer"; "text" = "The Kalyan Chart is a historical record log book of Satta Matka draw results for the Kalyan market. It presents the daily opening and closing Jodi numbers arranged week-by-week." }
        },
        @{
            "@type" = "Question"
            "name" = "How often are results updated?"
            "acceptedAnswer" = @{ "@type" = "Answer"; "text" = "Results on Kalyan Ka Chart Fix are updated in real-time. The Kalyan draw open result is published at 03:45 PM and the close result at 05:45 PM daily except Sundays." }
        },
        @{
            "@type" = "Question"
            "name" = "What is a Red Jodi?"
            "acceptedAnswer" = @{ "@type" = "Answer"; "text" = "A Red Jodi is either a double digit (e.g. 55) or a cut jodi (where the two digits differ by 5, e.g. 16, 27). These are highlighted in red to assist guessers in mathematical analysis." }
        }
    )
} | ConvertTo-Json -Depth 5

# Home Page H1 and paragraph
$homeH1 = "Kalyan Chart - Live Kalyan Matka Jodi Chart"
$homeIntro = "Welcome to kalyankachartfix.github.io, the most trusted and updated platform for Kalyan Chart historical records. The Kalyan market is one of the most prominent Satta Matka games in India, commanding a huge player base. Our Jodi chart offers day-by-day and week-by-week results tracking. Analyzing the Kalyan Jodi record is crucial for enthusiasts aiming to formulate patterns and guess the next winning numbers. By reviewing Red Jodis (doubles and cut numbers) and panel trends, players can identify repeat sequences. Our Kalyan chart updates dynamically in real-time as soon as the results are declared. Bookmark this page for the fastest Kalyan results!"

$homeHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kalyan Chart - Live Kalyan Matka Jodi Chart Record Book 2026</title>
  <meta name="description" content="Get the fastest Kalyan Chart, Kalyan Matka Jodi Record Book, Kalyan historical panel chart results. Super fast updates, red jodis, and mobile-friendly Kalyan chart online.">
  <link rel="canonical" href="$domain/">
  
  <!-- Open Graph -->
  <meta property="og:title" content="Kalyan Chart - Live Kalyan Matka Jodi Chart Record Book 2026">
  <meta property="og:description" content="Get the fastest Kalyan Chart, Kalyan Matka Jodi Record Book, Kalyan historical panel chart results. Super fast updates, red jodis, and mobile-friendly Kalyan chart online.">
  <meta property="og:url" content="$domain/">
  <meta property="og:type" content="website">
  <meta property="og:image" content="$domain/assets/images/og-image.jpg">
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Kalyan Chart - Live Kalyan Matka Jodi Chart Record Book 2026">
  <meta name="twitter:description" content="Get the fastest Kalyan Chart, Kalyan Matka Jodi Record Book, Kalyan historical panel chart results. Super fast updates, red jodis, and mobile-friendly Kalyan chart online.">
  <meta name="twitter:image" content="$domain/assets/images/og-image.jpg">

  <!-- Style Sheets -->
  <link rel="stylesheet" href="/assets/css/style.min.css">
  
  <!-- Schema Markup -->
  <script type="application/ld+json">
  $homeOrgSchema
  </script>
  <script type="application/ld+json">
  $homeFaqSchema
  </script>
</head>
<body>
  $headerHtml

  <main class="container">
    <section class="card-section chart-section" style="margin-top: 1.5rem;">
      <h1>$homeH1</h1>
      <p class="intro-paragraph" style="color: var(--text-secondary); font-size: 1rem; margin-top: 0.5rem; margin-bottom: 1rem; line-height: 1.6;">
        $homeIntro
      </p>
      
      <!-- Refresh Button immediately after heading paragraph -->
      <div style="margin-bottom: 1.5rem;">
        $refreshBtnHtml
      </div>

      <!-- Chart Toolbar Filters & Exports -->
      <div class="chart-toolbar">
        <div class="toolbar-filters">
          <select class="toolbar-select" id="filter-year">
            $yearOptionsHtmlHome
          </select>
          <input type="text" class="toolbar-input" id="search-chart-data" placeholder="Search Jodi records...">
        </div>
        <div class="toolbar-actions">
          <button class="btn-action" id="btn-copy" title="Copy visible rows">
            <svg viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>
            Copy
          </button>
          <button class="btn-action" id="btn-print" title="Print Chart">
            <svg viewBox="0 0 24 24"><path d="M19 8H5c-1.66 0-3 1.34-3 3v6h4v4h12v-4h4v-6c0-1.66-1.34-3-3-3zm-3 11H8v-5h8v5zm3-7c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm-1-9H6v4h12V3z"/></svg>
            Print
          </button>
          <button class="btn-action" id="btn-pdf" title="Save PDF">
            <svg viewBox="0 0 24 24"><path d="M20 2H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-8.5 7.5c0 .83-.67 1.5-1.5 1.5H9v2H7.5V7H10c.83 0 1.5.67 1.5 1.5v1zm5 2c0 .83-.67 1.5-1.5 1.5h-2.5V7H15c.83 0 1.5.67 1.5 1.5v3zm4-3H19v1h1.5V11H19v2h-1.5V7h3v1.5zM9 8.5H10v1H9v-1zm5 1.5h1v1.5h-1v-1.5z"/></svg>
            PDF
          </button>
          <button class="btn-action" id="btn-excel" title="Download Excel">
            <svg viewBox="0 0 24 24"><path d="M21.17 3.25Q21.5 3.25 21.75 3.5T22 4V20Q22 20.5 21.75 20.75T21.17 21H7.83Q7.5 21 7.25 20.75T7 20V17H2.83Q2.5 17 2.25 16.75T2 16.25V7.75Q2 7.25 2.25 7T2.83 6.75H7V4Q7 3.5 7.25 3.25T7.83 3H21.17zM19 5H9V7H19V5zm0 4H9V11H19V9zm0 4H9V15H19V13zm0 4H9V19H19V17zM15 9.5l-1-1.5-1 1.5h-.75l1.3-2-1.3-2H14l1 1.5 1-1.5h.75l-1.3 2 1.3 2H15z"/></svg>
            Excel
          </button>
        </div>
      </div>

      $kalyanTableHtml
    </section>

    <!-- Recent Results Panel -->
    <section class="card-section">
      <h2 class="section-title">Live Draw Results</h2>
      <div class="results-grid">
        $recentCardsHtml
      </div>
    </section>

    <!-- Market Links Directory -->
    <section class="card-section">
      <h2 class="section-title">Satta Matka Charts Directory</h2>
      <div class="markets-grid">
        $marketLinksHtml
      </div>
    </section>

    <!-- FAQ Section -->
    <section class="card-section">
      <h2 class="section-title">Frequently Asked Questions</h2>
      $homeFaqsHtml
    </section>

    $disclaimerHtml
  </main>

  $footerHtml

  <script src="/assets/js/main.min.js"></script>
</body>
</html>
"@

Set-Content -Path (Join-Path $outDir "index.html") -Value $homeHtml -Encoding utf8
Write-Host "Homepage index.html built successfully."

# ----------------- BUILD SUBPAGES -----------------

foreach ($m in $markets) {
    Write-Host "Building subpage: $($m.name)..."
    
    # Create subpage directory if not exists
    $subDir = Join-Path $outDir $m.id
    if (!(Test-Path $subDir)) { New-Item -ItemType Directory -Force -Path $subDir }
    
    # Load JSON data
    $jsonFileName = $m.id + ".json"
    $jsonPath = Join-Path $dataDir $jsonFileName
    if (!(Test-Path $jsonPath)) {
        Write-Warning "JSON file not found: $jsonPath. Skipping."
        continue
    }
    
    $jsonData = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
    
    # Build Table
    $yearOptionsHtml = ""
    $subpageTableHtml = Get-TableHtml -jsonData $jsonData -yearOptionsHtmlOut ([ref]$yearOptionsHtml)
    
    # Related Links
    $relatedLinksHtml = ""
    foreach ($rm in $markets) {
        if ($rm.id -ne $m.id) {
            $relatedLinksHtml += @"
        <a href="/$($rm.id)/" class="market-link-card">
          <span>$($rm.name)</span>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
        </a>
"@
        }
    }
    
    # FAQs
    $faqItemsHtml = ""
    $faqSchemaList = @()
    foreach ($faq in $m.faqs) {
        $faqItemsHtml += @"
          <div class="faq-item">
            <button class="faq-question">
              $($faq.q)
              <svg viewBox="0 0 24 24"><path d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/></svg>
            </button>
            <div class="faq-answer">
              <p>$($faq.a)</p>
            </div>
          </div>
"@
        $faqSchemaList += @{
            "@type" = "Question"
            "name" = $faq.q
            "acceptedAnswer" = @{ "@type" = "Answer"; "text" = $faq.a }
        }
    }
    
    # Schemas
    $breadcrumbSchema = @{
        "@context" = "https://schema.org"
        "@type" = "BreadcrumbList"
        "itemListElement" = @(
            @{
                "@type" = "ListItem"
                "position" = 1
                "name" = "Home"
                "item" = "$domain/"
            },
            @{
                "@type" = "ListItem"
                "position" = 2
                "name" = $m.name
                "item" = "$domain/$($m.id)/"
            }
        )
    } | ConvertTo-Json -Depth 5

    $faqSchema = @{
        "@context" = "https://schema.org"
        "@type" = "FAQPage"
        "mainEntity" = $faqSchemaList
    } | ConvertTo-Json -Depth 5

    $articleSchema = @{
        "@context" = "https://schema.org"
        "@type" = "Article"
        "headline" = $m.title
        "description" = $m.desc
        "image" = "$domain/assets/images/og-image.jpg"
        "datePublished" = "2026-06-17"
        "dateModified" = $lastUpdated
        "author" = @{
            "@type" = "Organization"
            "name" = "Kalyan Ka Chart Fix"
            "url" = "$domain/"
        }
        "publisher" = @{
            "@type" = "Organization"
            "name" = "Kalyan Ka Chart Fix"
            "logo" = @{
                "@type" = "ImageObject"
                "url" = "$domain/assets/images/logo.png"
            }
        }
    } | ConvertTo-Json -Depth 5

    # Subpage HTML Template
    $subpageHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$($m.title)</title>
  <meta name="description" content="$($m.desc)">
  <link rel="canonical" href="$domain/$($m.id)/">
  
  <!-- Open Graph -->
  <meta property="og:title" content="$($m.title)">
  <meta property="og:description" content="$($m.desc)">
  <meta property="og:url" content="$domain/$($m.id)/">
  <meta property="og:type" content="article">
  <meta property="og:image" content="$domain/assets/images/og-image.jpg">
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$($m.title)">
  <meta name="twitter:description" content="$($m.desc)">
  <meta name="twitter:image" content="$domain/assets/images/og-image.jpg">

  <!-- Style Sheets -->
  <link rel="stylesheet" href="/assets/css/style.min.css">
  
  <!-- Schema Markup -->
  <script type="application/ld+json">
  $breadcrumbSchema
  </script>
  <script type="application/ld+json">
  $faqSchema
  </script>
  <script type="application/ld+json">
  $articleSchema
  </script>
</head>
<body>
  $headerHtml

  <main class="container">
    <!-- Breadcrumbs -->
    <nav class="breadcrumbs" aria-label="Breadcrumb" style="margin-top: 1rem;">
      <a href="/">Home</a>
      <span class="separator">&gt;</span>
      <span class="current">$($m.name)</span>
    </nav>

    <!-- Chart Section -->
    <section class="card-section chart-section" style="margin-top: 0.5rem;">
      <h1>$($m.name)</h1>
      
      <!-- H1 followed immediately by introductory paragraph -->
      <p class="intro-paragraph" style="color: var(--text-secondary); font-size: 1rem; margin-top: 0.5rem; margin-bottom: 1rem; line-height: 1.6;">
        $($m.intro)
      </p>

      <!-- Refresh Button immediately after heading paragraph -->
      <div style="margin-bottom: 1.5rem;">
        $refreshBtnHtml
      </div>

      <!-- Chart Toolbar Filters & Exports -->
      <div class="chart-toolbar">
        <div class="toolbar-filters">
          <select class="toolbar-select" id="filter-year">
            $yearOptionsHtml
          </select>
          <input type="text" class="toolbar-input" id="search-chart-data" placeholder="Search Jodi records...">
        </div>
        <div class="toolbar-actions">
          <button class="btn-action" id="btn-copy" title="Copy visible rows">
            <svg viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>
            Copy
          </button>
          <button class="btn-action" id="btn-print" title="Print Chart">
            <svg viewBox="0 0 24 24"><path d="M19 8H5c-1.66 0-3 1.34-3 3v6h4v4h12v-4h4v-6c0-1.66-1.34-3-3-3zm-3 11H8v-5h8v5zm3-7c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm-1-9H6v4h12V3z"/></svg>
            Print
          </button>
          <button class="btn-action" id="btn-pdf" title="Save PDF">
            <svg viewBox="0 0 24 24"><path d="M20 2H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-8.5 7.5c0 .83-.67 1.5-1.5 1.5H9v2H7.5V7H10c.83 0 1.5.67 1.5 1.5v1zm5 2c0 .83-.67 1.5-1.5 1.5h-2.5V7H15c.83 0 1.5.67 1.5 1.5v3zm4-3H19v1h1.5V11H19v2h-1.5V7h3v1.5zM9 8.5H10v1H9v-1zm5 1.5h1v1.5h-1v-1.5z"/></svg>
            PDF
          </button>
          <button class="btn-action" id="btn-excel" title="Download Excel">
            <svg viewBox="0 0 24 24"><path d="M21.17 3.25Q21.5 3.25 21.75 3.5T22 4V20Q22 20.5 21.75 20.75T21.17 21H7.83Q7.5 21 7.25 20.75T7 20V17H2.83Q2.5 17 2.25 16.75T2 16.25V7.75Q2 7.25 2.25 7T2.83 6.75H7V4Q7 3.5 7.25 3.25T7.83 3H21.17zM19 5H9V7H19V5zm0 4H9V11H19V9zm0 4H9V15H19V13zm0 4H9V19H19V17zM15 9.5l-1-1.5-1 1.5h-.75l1.3-2-1.3-2H14l1 1.5 1-1.5h.75l-1.3 2 1.3 2H15z"/></svg>
            Excel
          </button>
        </div>
      </div>

      $subpageTableHtml
    </section>

    <!-- SEO Content Section -->
    <section class="card-section">
      <h2 class="section-title">About $($m.name) Records</h2>
      <div class="seo-text">
        <p>
          Analyzing historical charts plays a fundamental role in Satta Matka guessing models. By studying sequences of numbers and how they repeat across different months, experienced guessers determine balance patterns. Red jodis (double digits or cut pairs) highlight key transition lines, which is crucial for building next-draw forecasts.
        </p>
      </div>
    </section>

    <!-- FAQs Section -->
    <section class="card-section">
      <h2 class="section-title">Frequently Asked Questions</h2>
      <div class="faq-list">
        $faqItemsHtml
      </div>
    </section>

    <!-- Related Markets internal links -->
    <section class="card-section">
      <h2 class="section-title">Other Satta Matka Charts</h2>
      <div class="markets-grid">
        $relatedLinksHtml
      </div>
    </section>

    $disclaimerHtml
  </main>

  $footerHtml

  <script src="/assets/js/main.min.js"></script>
</body>
</html>
"@

    $subpagePath = Join-Path (Join-Path $outDir $m.id) "index.html"
    Set-Content -Path $subpagePath -Value $subpageHtml -Encoding utf8
    Write-Host "Subpage $($m.name) compiled at $subpagePath."
}

# ----------------- BUILD SITEMAP & ROBOTS -----------------

Write-Host "Generating sitemap.xml..."
$sitemapXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>$domain/</loc>
    <lastmod>$lastUpdated</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
"@

foreach ($m in $markets) {
    $sitemapXml += @"
  <url>
    <loc>$domain/$($m.id)/</loc>
    <lastmod>$lastUpdated</lastmod>
    <changefreq>daily</changefreq>
    <priority>0.8</priority>
  </url>
"@
}
$sitemapXml += "`n</urlset>"
Set-Content -Path (Join-Path $outDir "sitemap.xml") -Value $sitemapXml -Encoding utf8

Write-Host "Generating robots.txt..."
$robotsTxt = @"
User-agent: *
Allow: /

Sitemap: $domain/sitemap.xml
"@
Set-Content -Path (Join-Path $outDir "robots.txt") -Value $robotsTxt -Encoding utf8

Write-Host "Sitemap and robots.txt generated successfully!"
Write-Host "COMPILATION COMPLETE! Web files are in $outDir"
