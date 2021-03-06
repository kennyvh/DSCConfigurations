﻿@{
	AllNodes = @(
		@{
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
			Role = 'FirstDC'
			NodeName = 'DEMO-DC03'
			DomainDistinguishedName = 'DC=kennyvh,DC=local'
			DomainNetbiosName = 'kennyvh'
			Departments = @(
				'Finance'
				'IT'
				'Legal'
				'CustomerService'
			)
			SubOUs = @(
				'Computers'
				'Groups'
				'Users'
				'Shares'
			)
		},
		@{
			Role = 'SecondDC'
			NodeName = 'DEMO-DC04'
			RetryIntervalSec = 30
			RetryCount = 20
		}
	)
}

