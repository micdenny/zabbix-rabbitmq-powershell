[CmdletBinding()]
param(
    [string]$Server = "http://localhost:15672/api",
    [string]$Username = "guest",
    [string]$Password = "guest",
    [string]$Item = ""
)

function Get-Overview($Server, $Credential)
{
    $overviewUri = "$Server/overview"
    $overview = (Invoke-RestMethod -Credential $Credential -Uri $overviewUri)
    Write-Verbose (ConvertTo-Json $overview)
    return $overview
}

function Write-Numeric($Number)
{
    if ($Number -or $Number -eq "0")
    {
        Write-Host $Number.ToString("0")
    }
    else
    {
        Write-Host -1
    }
}

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)

if ($Item -eq "message_stats_deliver_get_rate")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.message_stats.deliver_get_details.rate
}
elseif ($Item -eq "message_stats_publish_rate")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.message_stats.publish_details.rate
}
elseif ($Item -eq "message_stats_ack_rate")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.message_stats.ack_details.rate
}
elseif ($Item -eq "message_totals_ready")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.queue_totals.messages_ready
}
elseif ($Item -eq "message_totals_unack")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.queue_totals.messages_unacknowledged
}
elseif ($Item -eq "message_totals_total")
{
    $overview = Get-Overview -Server $Server -Credential $credential
    Write-Numeric -Number $overview.queue_totals.messages
}
else
{
    Write-Host "Not Found"
}