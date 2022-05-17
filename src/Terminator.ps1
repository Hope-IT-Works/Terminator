<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Terminator
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,90)
$Form.text                       = "Terminator"
$Form.TopMost                    = $true

$ComboBoxProzesse                = New-Object system.Windows.Forms.ComboBox
$ComboBoxProzesse.width          = 370
$ComboBoxProzesse.height         = 20
$ComboBoxProzesse.location       = New-Object System.Drawing.Point(15,14)
$ComboBoxProzesse.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonAktualisieren             = New-Object system.Windows.Forms.Button
$ButtonAktualisieren.text        = "Aktualisieren"
$ButtonAktualisieren.width       = 100
$ButtonAktualisieren.height      = 30
$ButtonAktualisieren.location    = New-Object System.Drawing.Point(210,45)
$ButtonAktualisieren.Font        = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonBeenden                   = New-Object system.Windows.Forms.Button
$ButtonBeenden.text              = "Beenden"
$ButtonBeenden.width             = 70
$ButtonBeenden.height            = 30
$ButtonBeenden.location          = New-Object System.Drawing.Point(315,45)
$ButtonBeenden.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LabelInformation                = New-Object system.Windows.Forms.Label
$LabelInformation.text           = "Version 1.1.0.0`n© Tobias Meyer"
$LabelInformation.AutoSize       = $true
$LabelInformation.width          = 25
$LabelInformation.height         = 10
$LabelInformation.location       = New-Object System.Drawing.Point(15,45)
$LabelInformation.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LabelInformation.ForeColor      = [System.Drawing.ColorTranslator]::FromHtml("#4a4a4a")

$Form.controls.AddRange(@($ComboBoxProzesse,$ButtonAktualisieren,$ButtonBeenden,$LabelInformation))

$ButtonAktualisieren.Add_Click({ Prozesse-Aktualisieren })
$ButtonBeenden.Add_Click({ Prozess-Beenden })

#Advanced Styling
    $Form.ShowIcon                       = $false
    $Form.MaximizeBox                    = $false
    $Form.StartPosition                  = "CenterScreen"
    $Form.FormBorderStyle                = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $ComboBoxProzesse.AutoCompleteMode   = [System.Windows.Forms.AutoCompleteMode]::SuggestAppend
    $ComboBoxProzesse.AutoCompleteSource = [System.Windows.Forms.AutoCompleteSource]::CustomSource
    $ComboBoxProzesse.ContextMenu        = New-Object System.Windows.Forms.ContextMenu


function Prozess-Beenden {
    $Prozess = $ComboBoxProzesse.SelectedItem
    foreach($ProzessEintrag in $Prozesse) {
        Write-Host -ForegroundColor Yellow $ProzessEintrag
        if($ProzessEintrag -eq $Prozess) {
            $Abfrage = [System.Windows.Forms.MessageBox]::Show("Soll $Prozess beendet werden?","Target Verification",4,[System.Windows.Forms.MessageBoxIcon]::Question)
            if($Abfrage -eq "Yes") {
                Stop-Process -Name $ComboBoxProzesse.SelectedItem -Force
                Prozesse-Aktualisieren
                $ComboBoxProzesse.Text = ""
            } elseif($Abfrage -eq "No") {
                Prozesse-Aktualisieren
                $ComboBoxProzesse.Text = ""
            }
            return
        } else {
            $NichtGefunden = $true
        }
    }
    if($true -eq $NichtGefunden) {
        return [void] [System.Windows.Forms.MessageBox]::Show("Kein Prozess ausgewählt!","Target Verification",0,[System.Windows.Forms.MessageBoxIcon]::Warning)
    }
    Prozesse-Aktualisieren
}

function Prozesse-Aktualisieren {
    $Prozesse = (Get-Process).Name | Select-Object -Unique
    Set-Variable -Name "Prozesse" -Scope global
    $ComboBoxProzesse.Items.Clear()
    foreach($Prozess in $Prozesse) {
        [void] $ComboBoxProzesse.Items.Add($Prozess)
    }
    $ComboBoxProzesse.AutoCompleteCustomSource.Clear()
    $ComboBoxProzesse.AutoCompleteCustomSource.AddRange(($Prozesse))
}

#Initial Listing
    $Prozesse = (Get-Process).Name | Select-Object -Unique
    Set-Variable -Name "Prozesse" -Scope global
    $ComboBoxProzesse.Items.Clear()
    foreach($Prozess in $Prozesse) {
        [void] $ComboBoxProzesse.Items.Add($Prozess)
    }
    $ComboBoxProzesse.AutoCompleteCustomSource.AddRange(($Prozesse))
[void]$Form.ShowDialog()
