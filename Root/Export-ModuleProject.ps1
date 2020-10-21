function Export-ModuleProject {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({(Assert-ModuleProjectExists)})]
        [ArgumentCompleter({(Get-ModuleProjectChoices)})]
        [string] $NestedModule,

        [Parameter(Mandatory=$true)][string] $Destination,
        [String] $Author,
        [String] $CompanyName,
        [String] $Copyright,
        [Version] $ModuleVersion,
        [String] $Description,
        [String[]] $Tags,
        [Uri] $ProjectUri,
        [Uri] $LicenseUri,
        [Uri] $IconUri,
        [String] $ReleaseNotes,
        [String] $HelpInfoUri
    )  
    $NestedModuleLocation = Get-NestedModuleLocation -NestedModule $NestedModule

    $ModuleManifestParameters = @{}
    Add-InputParametersToObject -BoundParameters $PSBoundParameters `
        -ObjectToPopulate $ModuleManifestParameters `
        -Keys @(
            'Author',
            'CompanyName',
            'Copyright',
            'ModuleVersion',
            'Description',
            'Tags',
            'ProjectUri',
            'LicenseUri',
            'IconUri',
            'ReleaseNotes',
            'HelpInfoUri'
        )

    Update-ModuleProject -NestedModule $NestedModule @ModuleManifestParameters 

    $ModuleDirectories = $env:PSModulePath.Split(';')
    if ($ModuleDirectories -contains $Destination) {
        throw 'Cannot export module to a PSModule directory. Export-ModuleProject should be used to export your Nested Module to be imported into the QuickModuleCLI package. If you wish to package the module for import as a separate module, use the command Split-ModuleProject instead.'
    }

    Copy-Item -Path $NestedModuleLocation -Destination $Destination -Recurse;
}