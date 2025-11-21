Add-Type -ReferencedAssemblies "System.Management" -TypeDefinition @"
using System;
using System.Management;

public class SystemEvents
{
    public static DateTime? GetLastLogin()
    {
        try
        {
            var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_LogonSession WHERE LogonType=2");
            DateTime latest = DateTime.MinValue;
	 
            foreach (ManagementObject session in searcher.Get())
            {
                DateTime start = ManagementDateTimeConverter.ToDateTime(session["StartTime"].ToString());
                if (start > latest)
                    latest = start;
            }
            return latest;
        }
        catch { return null; }
    }

    public static TimeSpan? GetLastPowerCycleDuration()
    {
        try
        {
            var log = new System.Diagnostics.EventLog("System");
            DateTime? boot = null, shutdown = null;

            foreach (System.Diagnostics.EventLogEntry entry in log.Entries)
            {
                if ((entry.InstanceId & 0xFFFF) == 6005) boot = entry.TimeGenerated;
                if ((entry.InstanceId & 0xFFFF) == 6006) shutdown = entry.TimeGenerated;
            }

            if (boot.HasValue && shutdown.HasValue)
                return boot.Value - shutdown.Value;
        }
        catch { return null; }

        return null;
    }
}
"@

$ComputerName = $env:COMPUTERNAME
$LastLogin = [SystemEvents]::GetLastLogin()
$LocalFilePath = 'C:\ProgramData\Data\TestLogin.csv' 
$LocalFilePath2 = 'C:\ProgramData\Data\TestPowerCycle.csv' 

if($LastLogin -ne $null)
{
$ExportData = $LastLogin | Select-Object Year, Month, Day, Hour, Minute, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}
$ExportData | Export-Csv -Path $LocalFilePath -Append -NoTypeInformation

}

$PowerCycle = [SystemEvents]::GetLastPowerCycleDuration()

if($PowerCycle -ne $null)
{
$ExportData = $PowerCycle | Select-Object TotalMinutes, TotalSeconds, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}
$ExportData | Export-Csv -Path $LocalFilePath2 -Append -NoTypeInformation
}



