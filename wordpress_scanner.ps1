# script arguments
param(
    [String] $Url
)

function WordPress-Detection {
 
    param(
        [String] $url,
        [String] $type
    )
    $pattern_plugins = "/wp-content/plugins/([^/]+)/.*?\?ver=([0-9.]+)"
    $pattern_themes = "/wp-content/themes/([^/]+)/.*?\?ver=([0-9.]+)"
    $pattern_wp_ver  = 'meta name="generator" content="WordPress ([0-9.]+)"'
    $content = (Invoke-WebRequest -Uri $url -UserAgent "Mozilla/5.0 (platform; rv:gecko-version) Gecko/gecko-trail Firefox/firefox-version").Content
    if( $content -match $pattern_wp_ver){
        echo "[+] Wordpress Version : $($matches[1])"
    }
    if($type -eq "plugin"){
        $regex = [regex]::Matches($content,$pattern_plugins)
        $result = foreach($match in $regex){
          [PSCustomObject]@{
            Name = $match.Groups[1].Value
            Version = $match.Groups[2].Value
          }
        
        }
        $result | Sort-Object Name,Version -Unique | ForEach-Object  {
            Write-Host ("[+] Plugin : $($_.Name) - [+] Version : $($_.Version)")
        }
    }else{
        $regex = [regex]::Matches($content,$pattern_themes)
        $result = foreach($match in $regex){
          [PSCustomObject]@{
            Name = $match.Groups[1].Value
            Version = $match.Groups[2].Value
          }
        
        }
        $result | Sort-Object Name,Version -Unique | ForEach-Object  {
            Write-Host ("[+] Theme : $($_.Name) - [+] Version : $($_.Version)")
        }
    }
} 

WordPress-Detection -url $Url -type "plugin"
WordPress-Detection -url $Url -type "theme"