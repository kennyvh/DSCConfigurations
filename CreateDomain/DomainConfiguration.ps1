#requires -modules xActiveDirectory
Configuration NewDomain {
    Param (
        [Parameter(Mandatory)]
        [PSCredential]$DomainAdminCredential,
        [Parameter(Mandatory)]
        [PSCredential]$AdminCredential
    )
    Import-DscResource -ModuleName xActiveDirectory,PSDesiredStateConfiguration

    Node $AllNodes.Where({$_.Role -eq 'FirstDC'}).NodeName {
        $Node.WindowsFeatures.Foreach({
            WindowsFeature $_ {
                Name   = $_
                Ensure = 'Present'
            }
        })
        xADDomain $Node.DomainName {
            DomainName                    = $Node.DomainName
            DomainAdministratorCredential = $AdminCredential
            SafemodeAdministratorPassword = $AdminCredential
            DomainNetbiosName             = $Node.DomainNetbiosName
            DependsOn                     = '[WindowsFeature]AD-Domain-Services'
        }
        foreach ($Department in $Node.Departments) {
            xADOrganizationalUnit $Department {
                Name                            = $Department
                Path                            = $Node.DomainDistinguishedName
                Ensure                          = 'Present'
                Credential                      = $DomainAdminCredential
            }
        
            $Node.SubOUs.Foreach({
                xADOrganizationalUnit "$Department+$_" {
                    Name                            = $_
                    Path                            = "OU=$Department,$($Node.DomainDistinguishedName)"
                    Ensure                          = 'Present'
                    Credential                      = $DomainAdminCredential
                }
            })
        }
    }
    Node $AllNodes.Where({$_.Role -eq 'SecondDC'}).NodeName {
        $Node.WindowsFeatures.Foreach({
            WindowsFeature $_ {
                Name   = $_
                Ensure = 'Present'
            }
        })
        xWaitForADDomain FirstDC {
            DomainName = $Node.DomainName
            DomainUserCredential = $DomainAdminCredential
            RetryIntervalSec = $Node.RetryIntervalSec
            RetryCount = $Node.RetryCount
            DependsOn = '[WindowsFeature]AD-Domain-Services'
        }
        xADDomainController $Node.NodeName {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $DomainAdminCredential
            SafemodeAdministratorPassword = $AdminCredential
            DependsOn = '[xWaitForADDomain]FirstDC'
        }
    }
}

$params = @{
    OutputPath = 'C:\temp'
    ConfigurationData = 'C:\temp\DomainConfigData.psd1'
    DomainAdminCredential = (Get-Credential -Message 'DomainAdminCreds')
    AdminCredential = (Get-Credential -Message 'LocalAdminCreds')
}

NewDomain @params