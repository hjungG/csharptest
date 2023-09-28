# Pulls email status reports
Param(
	[Parameter(Mandatory=$true)]
    [string]$ServerName,
    [Parameter(Mandatory=$true)]
    [string]$Username,
    [Parameter(Mandatory=$true)]
    [string]$Password,
	[Parameter(Mandatory=$true)]
    [string]$ProcessEmailReportName,
	[Parameter(Mandatory=$true)]
    [string]$TotalEmailReportName
)

$Date = Get-Date -format "MM-dd-yyyy"
$currentDir = Get-Location
$ProcessEmailReportName = "$ProcessEmailReportName.csv"
$TotalEmailReportName = "$TotalEmailReportName.csv"

$db_list = ('GlobalPolaris_Shard0','GlobalPolaris_Shard1')
$process_email_status_qry = "SELECT ProcessName
    ,SUM(CASE 
            WHEN STATUS = 'Error'
                THEN 1
            ELSE 0
            END) AS 'Error'
    ,SUM(CASE 
            WHEN STATUS = 'enqueued'
                THEN 1
            ELSE 0
            END) AS 'Enqueued'
    ,SUM(CASE 
            WHEN STATUS = 'enqueued-failed'
                THEN 1
            ELSE 0
            END) AS 'EnqueuedFailed'
FROM [dbo].[EmailTimerHistory]
WHERE CONVERT(DATE, CreatedDate) = CONVERT(DATE, GETDATE() - 1)
GROUP BY CONVERT(DATE, CreatedDate)
    ,ProcessName"

$total_email_status_qry = "SELECT CONVERT(DATE, TimeStamp) AS [TimeStamp]
    ,SUM(CASE 
            WHEN EmailStatus = 'Sent-Success'
                THEN 1
            ELSE 0
            END) AS 'SentSuccess'
    ,SUM(CASE 
            WHEN EmailStatus = 'Sent-Failure'
                THEN 1
            ELSE 0
            END) AS 'SentFailure'
    ,SUM(CASE 
            WHEN EmailStatus = 'Enqueue-For-Send'
                THEN 1
            ELSE 0
            END) AS 'EnqueueForSend'
FROM [dbo].[UserEmails]
WHERE CONVERT(DATE, TimeStamp) = CONVERT(DATE, GETDATE() - 1)
GROUP BY CONVERT(DATE, TimeStamp)"

$error_hsh = @{}
$enqueued_hsh = @{}
$enqueuedFailed_hsh = @{}

$sent_success_hsh = @{}
$sent_failure_hsh = @{}
$enqueue_for_send_hsh = @{}

foreach ($db in $db_list)
{
    echo $db
   
    $email_status_result = Invoke-sqlcmd  -ServerInstance $ServerName -Database $db  -Username $Username -Password $Password -Query $process_email_status_qry
    $total_email_status_result = Invoke-sqlcmd  -ServerInstance $ServerName -Database $db  -Username $Username -Password $Password -Query $total_email_status_qry
    # $email_status_result | Format-Table -AutoSize    
            
    foreach ($recs in $email_status_result)
    {
        $error_hsh[$recs.ProcessName] += $recs.Error
        $enqueued_hsh[$recs.ProcessName] += $recs.Enqueued
        $enqueuedFailed_hsh[$recs.ProcessName] += $recs.EnqueuedFailed                
    }

    foreach ($recs in $total_email_status_result)
    {
        $TimeStamp = $recs.TimeStamp 
        $TimeStamp = $TimeStamp.ToString("MM-dd-yyyy")
        $sent_success_hsh[$TimeStamp] += $recs.SentSuccess
        $sent_failure_hsh[$TimeStamp] += $recs.SentFailure
        $enqueue_for_send_hsh[$TimeStamp] += $recs.EnqueueForSend                
    }
}


$process_email_status_final = @()

foreach ($ProcessName in $error_hsh.Keys){

    $process_status_result = [PSCustomObject]@{}
    # $CreatedDate = $recs.CreatedDate 
    # $CreatedDate = $CreatedDate.ToString("MM-dd-yyyy")
                 
    $process_status_result | Add-Member -MemberType NoteProperty -Name 'ProcessName' -Value $ProcessName
    [int]$error = $error_hsh[$ProcessName]
    $process_status_result | Add-Member -MemberType NoteProperty -Name 'Error' -Value $error
    [int]$enqueued = $enqueued_hsh[$ProcessName]
    $process_status_result | Add-Member -MemberType NoteProperty -Name 'Enqueued' -Value $enqueued
    [int]$enqueuedFailed = $enqueuedFailed_hsh[$ProcessName]
    $process_status_result | Add-Member -MemberType NoteProperty -Name 'EnqueuedFailed' -Value $enqueuedFailed            
    $process_email_status_final += $process_status_result
}

if ($process_email_status_final.count -gt 0){
    #$process_email_status_final | Select-Object ProcessName, Error, Enqueued, EnqueuedFailed
    $process_email_status_final | Export-Csv -Path "$currentDir\$ProcessEmailReportName" -Force -NoTypeInformation
}
else
{
    Write-Host "There are no email timer process emails triggered yesterday"
}

$ProcessFileExists = Test-Path -Path "$currentDir\$ProcessEmailReportName"
Write-Output "##vso[task.setvariable variable=ProcessFileExists]$ProcessFileExists"

$total_email_status_final = @()

foreach ($TimeStamp in $sent_success_hsh.Keys){

    $total_status_result = [PSCustomObject]@{}
                 
    $total_status_result | Add-Member -MemberType NoteProperty -Name 'Date' -Value $TimeStamp
    [int]$sent_success = $sent_success_hsh[$TimeStamp]
    $total_status_result | Add-Member -MemberType NoteProperty -Name 'SentSuccess' -Value $sent_success
    [int]$sent_failure = $sent_failure_hsh[$TimeStamp]
    $total_status_result | Add-Member -MemberType NoteProperty -Name 'SentFailure' -Value $sent_failure
    [int]$enqueued_for_send = $enqueue_for_send_hsh[$TimeStamp]
    $total_status_result | Add-Member -MemberType NoteProperty -Name 'EnqueuedForSend' -Value $enqueued_for_send            
    $total_email_status_final += $total_status_result
}

if ($total_email_status_final.count -gt 0){
    #$total_email_status_final | Select-Object CurrentDate, SentSuccess, SentFailure, EnqueuedForSend
    $total_email_status_final | Export-Csv -Path "$currentDir\$TotalEmailReportName" -Force -NoTypeInformation
}
else
{
    Write-Host "There are no emails triggered yesterday"
}

$TotalFileExists = Test-Path -Path "$currentDir\$TotalEmailReportName"
Write-Output "##vso[task.setvariable variable=TotalFileExists]$TotalFileExists"