@{
	AllNodes = @(
		@{
            #settings for all nodes
			NodeName = '*'
			PSDscAllowDomainUser = $true
			PSDscAllowPlainTextPassword = $true
			DomainName = 'kennyvh.local'
			WindowsFeatures = @(
				'AD-Domain-Services'
				'RSAT-AD-PowerShell'
				'RSAT-ADDS'
				'RSAT-AD-AdminCenter'
				'RSAT-ADDS-Tools'
			)
		},
		@{
            #first domain controller settings
			Role = 'FirstDC'
			NodeName = 'DEMO-DC03'
			DomainDistinguishedName = 'DC=kennyvh,DC=local'
			DomainNetbiosName = 'kennyvh'

            #OUs on domain level
			Departments = @(
				'Finance'
				'IT'
				'Legal'
				'CustomerService'
			)
            #SubOUs for each Department OU
			SubOUs = @(
				'Computers'
				'Groups'
				'Users'
				'Shares'
			)
		},
		@{
            #second domain controller settings
			Role = 'SecondDC'
			NodeName = 'DEMO-DC04'
			RetryIntervalSec = 30
			RetryCount = 20
		}
	)
}

