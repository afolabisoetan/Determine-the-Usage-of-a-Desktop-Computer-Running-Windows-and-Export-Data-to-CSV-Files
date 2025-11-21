This repository contains a PowerShell script designed to query and analyze specific Windows system event logs and databases to determine detailed usage statistics for a local desktop computer. The gathered data, including system uptime, idle time, and last logon times, is formatted and exported to a .csv file for easy analysis and reporting.

Key Features
  Usage Calculation: Computes the total uptime duration by analyzing Windows System Event IDs.
  Idle Time Analysis: Calculates daily, weekly, and monthly idle time based on system logs and processes.
  Last Logon Retrieval: Queries the $Win32\_LogonSession$ database to retrieve details on the last physical login time ($LogonType=2$).
  Process Analysis: Determines the earliest process start times to confirm system operation periods.
  CSV Export: Utilizes the built-in $Export-CSV$ cmdlet for clean, structured data output.
  Technical Focus: Demonstrates proficiency in using PowerShell's .NET Framework integration and WMI (Windows Management Instrumentation).
  
Technologies Used
  PowerShell
 .NET Framework (specifically $System.Management$ and $System.Diagnostics$)
  WMI (for system query)
  CSV Export
  
How to Use the Script
  Prerequisites
    A local machine running Windows 7 or newer.
    PowerShell 5.1 or newer.
    The user must have Administrator privileges to access certain system logs and WMI databases.
