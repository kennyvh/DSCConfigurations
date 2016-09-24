#region create .meta.mof and apply LCM config
$cimsessionDC03 = New-CimSession -ComputerName DEMO-DC03 -Credential (Get-Credential)
$cimsessionDC04 = New-CimSession -ComputerName DEMO-DC04 -Credential (Get-Credential)

$nodes = 'DEMO-DC04','DEMO-DC03'

[DscLocalConfigurationManager()]
Configuration LCM
{
    Node $nodes
    {
        Settings
        {
            RefreshMode          = 'Push'
            ConfigurationMode    = 'ApplyAndAutoCorrect'
            ActionAfterReboot    = 'ContinueConfiguration'
            RebootNodeIfNeeded   = $true
        }
    }
}
LCM -OutputPath 'C:\Temp'

Set-DscLocalConfigurationManager -Path 'C:\temp' -CimSession $cimsessionDC03,$cimsessionDC04 -Verbose -Force

#endregion