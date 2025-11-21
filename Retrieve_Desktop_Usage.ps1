Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Linq;

public class SystemUsage
{
    public static DateTime? GetSessionStart()
    {
        try
        {
            // Get all processes for the current user
            var currentUser = Environment.UserName;
            var processes = Process.GetProcesses().Where(p =>
            {
                try { return p.StartTime != null; }
                catch { return false; }
            });

            // Find the earliest process for this user
            var sessionStart = processes.Min(p => p.StartTime);
            return sessionStart;
        }
        catch
        {
            return null;
        }
    }

    public static TimeSpan? GetSessionDuration()
    {
        DateTime? start = GetSessionStart();
        if (start.HasValue)
        {
            return DateTime.Now - start.Value;
        }
        return null;
    }
}
"@

$ComputerName = $env:COMPUTERNAME
$Duration = [SystemUsage]::GetSessionDuration()

$LocalFilePath = 'C:\ProgramData\Data\TestSessionDuration.csv' 
$LocalFilePath2 = 'C:\ProgramData\Data\TestSessionStart.csv' 

if($Duration -ne $null)
{
$ExportData = $Duration | Select-Object TotalMinutes, TotalSeconds, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}


$ExportData | Export-Csv -Path $LocalFilePath -Append -NoTypeInformation

}

$Start = [SystemUsage]::GetSessionStart()

if($Start -ne $null)
{

$ExportData = $Start | Select-Object Year, Month, Day, Hour, Minute, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}

$ExportData | Export-Csv -Path $LocalFilePath2 -Append -NoTypeInformation
}


