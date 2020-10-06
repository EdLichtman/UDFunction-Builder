function Rename-QuickCommand {
    param(
        [Parameter(Mandatory=$true)][string] $NestedModule,
        [Parameter(Mandatory=$true)][string] $commandName,
        [Parameter(Mandatory=$true)][string] $replacement
    )

    . $PSScriptRoot\Reserved\Get-QuickEnvironment.ps1
    
    $Function = "$NestedModulesFolder\$NestedModule\Functions\$commandName.ps1"
    $Alias = "$NestedModulesFolder\$NestedModule\Aliases\$commandName.ps1"

    if(Test-Path $Function) {
        $FunctionBlock = Get-Content $Function -Raw
        $NewFunctionBlock = $FunctionBlock -Replace "$commandName", "$replacement" 
        
        Remove-QuickCommand -NestedModule $NestedModule -commandName $commandName
        Add-QuickFunction -NestedModule $NestedModule -functionName $replacement -functionText $NewFunctionBlock -Raw
    } elseif (Test-Path $Alias) {
        $aliasBlock = Get-Content $Alias -Raw
        $NewAliasBlock = $aliasBlock -Replace "Set-Alias $commandName", "Set-Alias $replacement" 
        
        Remove-QuickCommand -NestedModule $NestedModule -commandName $commandName
        Add-QuickAlias -NestedModule $NestedModule -aliasName $replacement -aliasText $NewAliasBlock -Raw
    } else {
        Write-Output "Command '$commandName' not found."
        return;
    }

}