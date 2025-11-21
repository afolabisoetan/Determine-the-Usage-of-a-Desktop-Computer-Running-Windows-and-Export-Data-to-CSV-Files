Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class IdleTime {
    [StructLayout(LayoutKind.Sequential)]
    struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }

static LASTINPUTINFO lii = new LASTINPUTINFO();


    [DllImport("user32.dll")]
    static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

  public static TimeSpan GetIdleTime() {
       PopulateStructureHelper ();
        uint idleTicks = ((uint)Environment.TickCount - lii.dwTime);
        return TimeSpan.FromMilliseconds(idleTicks);
    }

public static TimeSpan GetActiveTime () {
   PopulateStructureHelper ();
  return TimeSpan.FromMilliseconds (lii.dwTime);
}

private static void PopulateStructureHelper () 

{
        lii.cbSize = (uint)Marshal.SizeOf(lii);
        GetLastInputInfo(ref lii);
}
}
"@

$ComputerName = $env:COMPUTERNAME
$IdleTime = [IdleTime]::GetIdleTime()
$ActiveTime = [IdleTime]::GetActiveTime()
$LocalFilePath = 'C:\ProgramData\Data\TestIdle.csv' 

if($IdleTime.TotalMinutes -ge 60)
{
$ExportData = $IdleTime | Select-Object TotalMinutes, TotalSeconds, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}
$ExportData | Export-Csv -Path $LocalFilePath -Append -NoTypeInformation
}

$LocalFilePath2 = 'C:\ProgramData\Data\TestActive.csv' 

$ExportData = $ActiveTime | Select-Object TotalMinutes, TotalSeconds, @{Name='ComputerName'; Expression={$ComputerName}}, @{Name='TimeCaptured'; Expression={Get-Date -Format 'yyyy-MM-dd HH:mm:ss'}}
$ExportData | Export-Csv -Path $LocalFilePath2 -Append -NoTypeInformation
