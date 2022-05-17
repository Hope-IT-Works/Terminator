<# This form was created using POSHGUI.com a free online gui designer for PowerShell
.NAME
    Terminator
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                       = New-Object System.Windows.Forms.Form
$Form.ClientSize            = New-Object System.Drawing.Point(400,90)
$Form.Text                  = "Terminator"
$Form.TopMost               = $true

$ComboBoxProcesses          = New-Object System.Windows.Forms.ComboBox
$ComboBoxProcesses.width    = 370
$ComboBoxProcesses.height   = 20
$ComboBoxProcesses.location = New-Object System.Drawing.Point(15,14)
$ComboBoxProcesses.Font     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonRefresh              = New-Object System.Windows.Forms.Button
$ButtonRefresh.text         = "Refresh"
$ButtonRefresh.width        = 100
$ButtonRefresh.height       = 30
$ButtonRefresh.location     = New-Object System.Drawing.Point(210,45)
$ButtonRefresh.Font         = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonClose                = New-Object System.Windows.Forms.Button
$ButtonClose.text           = "Kill"
$ButtonClose.width          = 70
$ButtonClose.height         = 30
$ButtonClose.location       = New-Object System.Drawing.Point(315,45)
$ButtonClose.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LabelInformation           = New-Object System.Windows.Forms.Label
$LabelInformation.text      = "Version 1.3`n© Tobias Meyer"
$LabelInformation.AutoSize  = $true
$LabelInformation.width     = 25
$LabelInformation.height    = 10
$LabelInformation.location  = New-Object System.Drawing.Point(15,45)
$LabelInformation.Font      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LabelInformation.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#4a4a4a")

$Form.controls.AddRange(@($ComboBoxProcesses,$ButtonRefresh,$ButtonClose,$LabelInformation))

$ButtonRefresh.Add_Click({ Get-TerminatorProcess })
$ButtonClose.Add_Click({ Stop-TerminatorProcess })

#Advanced Styling
    $Form.ShowIcon                        = $false
    $Form.MaximizeBox                     = $false
    $Form.StartPosition                   = "CenterScreen"
    $Form.FormBorderStyle                 = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $ComboBoxProcesses.AutoCompleteMode   = [System.Windows.Forms.AutoCompleteMode]::SuggestAppend
    $ComboBoxProcesses.AutoCompleteSource = [System.Windows.Forms.AutoCompleteSource]::CustomSource
    $ComboBoxProcesses.ContextMenu        = New-Object System.Windows.Forms.ContextMenu

function Stop-TerminatorProcess {
    $Process = $ComboBoxProcesses.SelectedItem
    foreach($ProcessEntry in $Processes) {
        if($ProcessEntry -eq $Process) {
            $Query = [System.Windows.Forms.MessageBox]::Show("Should $Process be terminated?","Target Verification",4,[System.Windows.Forms.MessageBoxIcon]::Question)
            if($Query -eq "Yes") {
                Stop-Process -Name $ComboBoxProcesses.SelectedItem -Force -ErrorAction 'SilentlyContinue'
                Get-TerminatorProcess
                $ComboBoxProcesses.Text = ""
            } elseif($Query -eq "No") {
                Get-TerminatorProcess
                $ComboBoxProcesses.Text = ""
            }
            return
        } else {
            $ProcessNotFound = $true
        }
    }
    if($true -eq $ProcessNotFound) {
        return [void] [System.Windows.Forms.MessageBox]::Show("No Process selected!","Target Verification",0,[System.Windows.Forms.MessageBoxIcon]::Warning)
    }
    Get-TerminatorProcess
}

function Get-TerminatorProcess([Switch]$Init) {
    Set-Variable -Name "Processes" -Scope global
    $global:Processes = (Get-Process).Name | Select-Object -Unique
    $ComboBoxProcesses.Items.Clear()
    foreach($Process in $Processes) {
        [void] $ComboBoxProcesses.Items.Add($Process)
    }
    if($true -eq $Init){
        $ComboBoxProcesses.AutoCompleteCustomSource.Clear()
    }
    $ComboBoxProcesses.AutoCompleteCustomSource.AddRange($Processes)
}

#Initial Listing
Get-TerminatorProcess -Init
[void]$Form.ShowDialog()