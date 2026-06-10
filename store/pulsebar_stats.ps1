# PulseBar -- aggregate stats dashboard
# Run anytime: powershell -File pulsebar_stats.ps1  (or just double-click)
# Pulls public GitHub stats. Microsoft Store numbers stay in Partner Center.

$repo  = 'FokionPapanikolaou/PulseBar'
$store = '9P128R4SVXLC'

function Section($t) {
    Write-Host ''
    Write-Host $t -ForegroundColor Cyan
    Write-Host ('-' * $t.Length) -ForegroundColor DarkGray
}
function KV($k, $v, $col = 'White') {
    Write-Host ("  {0,-22}" -f $k) -NoNewline
    Write-Host $v -ForegroundColor $col
}
function URL($t, $u) {
    Write-Host ("  {0,-22}" -f $t) -NoNewline
    Write-Host $u -ForegroundColor Blue
}

Write-Host ''
Write-Host '==============================================================' -ForegroundColor Magenta
Write-Host '                 PulseBar -- Stats Dashboard                  ' -ForegroundColor Magenta
Write-Host '==============================================================' -ForegroundColor Magenta

# β”€β”€ GitHub repo basics β”€β”€
Section 'GitHub repository'
try {
    $r = Invoke-RestMethod "https://api.github.com/repos/$repo" -Headers @{'User-Agent' = 'PulseBar-stats'}
    KV 'Stars'       $r.stargazers_count 'Yellow'
    KV 'Forks'       $r.forks_count      'Green'
    KV 'Watchers'    $r.subscribers_count
    KV 'Open issues' $r.open_issues_count 'Yellow'
    KV 'Created'     ([datetime]$r.created_at).ToString('yyyy-MM-dd')
    KV 'Last push'   ([datetime]$r.pushed_at).ToString('yyyy-MM-dd HH:mm')
    KV 'Size on disk' ('{0:N0} KB' -f $r.size)
} catch {
    Write-Host ('  (could not fetch: ' + $_.Exception.Message + ')') -ForegroundColor Red
}

# β”€β”€ Release downloads β”€β”€
Section 'GitHub Releases (download counts)'
try {
    $rels = Invoke-RestMethod "https://api.github.com/repos/$repo/releases" -Headers @{'User-Agent' = 'PulseBar-stats'}
    $totalAll = 0
    foreach ($rel in $rels) {
        $sum = ($rel.assets | Measure-Object download_count -Sum).Sum
        $totalAll += $sum
        $date = ([datetime]$rel.published_at).ToString('yyyy-MM-dd')
        Write-Host ('  {0,-12} {1,8:N0} downloads   {2}' -f $rel.tag_name, $sum, $date)
        foreach ($a in $rel.assets) {
            Write-Host ('              -> {0,-26} {1,6:N0}' -f $a.name, $a.download_count) -ForegroundColor DarkGray
        }
    }
    Write-Host ''
    KV 'Total downloads' $totalAll 'Green'
} catch {
    Write-Host ('  (could not fetch: ' + $_.Exception.Message + ')') -ForegroundColor Red
}

# β”€β”€ Traffic (needs gh auth) β”€β”€
Section 'Traffic last 14 days (needs gh auth)'
$gh = (Get-Command gh -ErrorAction SilentlyContinue).Source
if (-not $gh) { $gh = 'C:\Program Files\GitHub CLI\gh.exe' }
if (Test-Path $gh) {
    try {
        $views  = & $gh api "repos/$repo/traffic/views"  2>$null | ConvertFrom-Json
        $clones = & $gh api "repos/$repo/traffic/clones" 2>$null | ConvertFrom-Json
        if ($views)  { KV 'Page views' ('{0,4} unique / {1,4} total' -f $views.uniques, $views.count) 'Cyan' }
        if ($clones) { KV 'Clones'     ('{0,4} unique / {1,4} total' -f $clones.uniques, $clones.count) 'Cyan' }
        $referrers = & $gh api "repos/$repo/traffic/popular/referrers" 2>$null | ConvertFrom-Json
        if ($referrers) {
            Write-Host '  Top referrers:'
            foreach ($ref in ($referrers | Select-Object -First 5)) {
                Write-Host ('    {0,-30}  {1,4} uniques  {2,4} clicks' -f $ref.referrer, $ref.uniques, $ref.count) -ForegroundColor DarkGray
            }
        }
    } catch {
        Write-Host ('  (traffic fetch failed: ' + $_.Exception.Message + ')') -ForegroundColor Red
    }
} else {
    Write-Host '  (gh CLI not found -- install for traffic stats)' -ForegroundColor DarkGray
}

# β”€β”€ Microsoft Store β”€β”€
Section 'Microsoft Store'
KV 'Store ID' $store 'Magenta'
URL 'Store page'   ('https://apps.microsoft.com/detail/' + $store)
URL 'Analytics'    'https://partner.microsoft.com/dashboard/insights/analytics/reports'
URL 'Acquisitions' 'https://partner.microsoft.com/dashboard/insights/analytics/acquisitions'
URL 'Ratings'      'https://partner.microsoft.com/dashboard/insights/analytics/ratings'
URL 'Reviews'      'https://partner.microsoft.com/dashboard/insights/analytics/reviews'
URL 'Health'       'https://partner.microsoft.com/dashboard/insights/analytics/health'

try {
    $r = Invoke-WebRequest ('https://apps.microsoft.com/detail/' + $store) -UseBasicParsing -TimeoutSec 6 -ErrorAction Stop
    if ($r.StatusCode -eq 200) {
        KV 'Store page status' 'live (HTTP 200)' 'Green'
    } else {
        KV 'Store page status' ('status ' + $r.StatusCode) 'Yellow'
    }
} catch {
    KV 'Store page status' ('unreachable: ' + $_.Exception.Message) 'Red'
}

# β”€β”€ Direct links β”€β”€
Section 'Direct links'
URL 'Repository'  ('https://github.com/' + $repo)
URL 'Releases'    ('https://github.com/' + $repo + '/releases')
URL 'Issues'      ('https://github.com/' + $repo + '/issues')
URL 'Discussions' ('https://github.com/' + $repo + '/discussions')
URL 'Landing'     'https://fokionpapanikolaou.github.io/PulseBar/'

Write-Host ''
Write-Host ('  Generated at ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')) -ForegroundColor DarkGray
Write-Host ''

