function fnc_reloadRSAT {

    $ListView1.Items.Clear()

    $SCRIPT:RSAT = Get-WindowsCapability -Name RSAT* -Online

    $popular = @("Active Directory Domain Services","DHCP","DNS","Group Policy","Server Manager","Update Services","BitLocker")
    
    foreach ($tool in $SCRIPT:RSAT) {
        $name = $tool.DisplayName -replace "RSAT:\s"
        $version = $tool.name -replace "Rsat.*~"
        $state = $tool.State
        $dlSize = "$([Math]::Ceiling($tool.DownloadSize/1MB)) MB"
        $installSize = "$([Math]::Ceiling($tool.InstallSize/1MB)) MB"
        $desc = $tool.Description

        $itm = $ListView1.Items.Add($name)
        $itm.ToolTipText = $desc
        $itm.Tag = $tool.name
        $itm.Group = if ($state -eq "Installed") {$ListViewGroup11} else {$ListViewGroup12}
        $itm.Checked = if ($state -ne "Installed") { $null -ne ($popular | ? { $name -Match $_ }) }
        $itm.UseItemStyleForSubItems = $false
        $itm.Subitems.Add($version)
        $itm.Subitems.Add($dlSize)
        $itm.Subitems.Add($installSize)
    }

    $ListView1.AutoResizeColumns([Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
	$ListView1.AutoResizeColumns([Windows.Forms.ColumnHeaderAutoResizeStyle]::HeaderSize)
}

function fnc_toggleButtons {
    $Button1.Enabled = !($Button1.Enabled)
    $Button2.Enabled = !($Button2.Enabled)
    $Button3.Enabled = !($Button3.Enabled)
    $Button4.Enabled = !($Button4.Enabled)
}

# Install Selected
$Button1_Click = {
    fnc_toggleButtons

    $ProgressBar1.Maximum = $ListView1.CheckedItems.Count
    $ProgressBar1.Minimum = 0
    $ProgressBar1.Value = 0
    $ProgressBar1.Step = 1

    foreach ($itm in $ListView1.CheckedItems) {
        $ProgressBar1.PerformStep()
        if ($itm.Group.Header -ne "Installed") {     
            Add-WindowsCapability -Name $itm.Tag –Online
        }
    }

    $ProgressBar1.PerformStep()
    fnc_reloadRSAT
    fnc_toggleButtons
    $ProgressBar1.Value = 0
}

#Install all
$Button2_Click = {
    fnc_toggleButtons

    $ProgressBar1.Maximum = $ListView1.Items.Count
    $ProgressBar1.Minimum = 0
    $ProgressBar1.Value = 0
    $ProgressBar1.Step = 1

    foreach ($itm in $ListView1.Items) {
        $ProgressBar1.PerformStep()
        if ($itm.Group.Header -ne "Installed") {     
            Add-WindowsCapability -Name $itm.Tag –Online
        }
    }

    $ProgressBar1.PerformStep()
    fnc_reloadRSAT
    fnc_toggleButtons
    $ProgressBar1.Value = 0
}

#Uninstall selected
$Button3_Click = {
    fnc_toggleButtons

    $ProgressBar1.Maximum = $ListView1.CheckedItems.Count
    $ProgressBar1.Minimum = 0
    $ProgressBar1.Value = 0
    $ProgressBar1.Step = 1

    foreach ($itm in $ListView1.CheckedItems) {
        $ProgressBar1.PerformStep()
        if ($itm.Group.Header -eq "Installed") {     
            Remove-WindowsCapability -Name $itm.Tag –Online
        }
    }

    $ProgressBar1.PerformStep()
    fnc_reloadRSAT
    fnc_toggleButtons
    $ProgressBar1.Value = 0
}

#Uninstall all
$Button4_Click = {
    fnc_toggleButtons

    $ProgressBar1.Maximum = $ListView1.Items.Count
    $ProgressBar1.Minimum = 0
    $ProgressBar1.Value = 0
    $ProgressBar1.Step = 1

    foreach ($itm in $ListView1.Items) {
        $ProgressBar1.PerformStep()
        if ($itm.Group.Header -eq "Installed") {     
            Remove-WindowsCapability -Name $itm.Tag –Online
        }
    }

    $ProgressBar1.PerformStep()
    fnc_reloadRSAT
    fnc_toggleButtons
    $ProgressBar1.Value = 0
}

$Form1_Load = {
    fnc_reloadRSAT
}

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[Windows.Forms.Application]::EnableVisualStyles()

#. (Join-Path $PSScriptRoot 'rsat.designer.ps1')

$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.ProgressBar]$ProgressBar1 = $null
[System.Windows.Forms.ListView]$ListView1 = $null
[System.Windows.Forms.Button]$Button1 = $null
[System.Windows.Forms.Button]$Button2 = $null
[System.Windows.Forms.Button]$Button3 = $null
[System.Windows.Forms.Button]$Button4 = $null

function InitializeComponent {
    $ProgressBar1 = (New-Object -TypeName System.Windows.Forms.ProgressBar)
    $ListView1 = (New-Object -TypeName System.Windows.Forms.ListView)
    $Button1 = (New-Object -TypeName System.Windows.Forms.Button)
    $Button2 = (New-Object -TypeName System.Windows.Forms.Button)
    $Button3 = (New-Object -TypeName System.Windows.Forms.Button)
    $Button4 = (New-Object -TypeName System.Windows.Forms.Button)
    $Form1.SuspendLayout()
    #
    #ProgressBar1
    #
    $ProgressBar1.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
    $ProgressBar1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]741))
    $ProgressBar1.Name = [System.String]'ProgressBar1'
    $ProgressBar1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]543,[System.Int32]23))
    $ProgressBar1.TabIndex = [System.Int32]0
    #
    #ListView1
    #
    $ListView1.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
    $ListView1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
    $ListView1.Name = [System.String]'ListView1'
    $ListView1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]543,[System.Int32]608))
    $ListView1.TabIndex = [System.Int32]1
    $ListView1.UseCompatibleStateImageBehavior = $false
    $ListView1.CheckBoxes = $true
    $ListView1.FullRowSelect = $true
    $ListView1.HideSelection = $false
    $ListView1.View = [System.Windows.Forms.View]::Details
    $ListView1.ShowItemToolTips = $true
    #
    #Button1
    #
    $Button1.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left)
    $Button1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]639))
    $Button1.Name = [System.String]'Button1'
    $Button1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]45))
    $Button1.TabIndex = [System.Int32]2
    $Button1.Text = [System.String]'Install Selected'
    $Button1.UseCompatibleTextRendering = $true
    $Button1.UseVisualStyleBackColor = $true
    $Button1.add_Click($Button1_Click)
    #
    #Button2
    #
    $Button2.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right)
    $Button2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]303,[System.Int32]639))
    $Button2.Name = [System.String]'Button2'
    $Button2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]45))
    $Button2.TabIndex = [System.Int32]3
    $Button2.Text = [System.String]'Install ALL'
    $Button2.UseCompatibleTextRendering = $true
    $Button2.UseVisualStyleBackColor = $true
    $Button2.add_Click($Button2_Click)
    #
    #Button3
    #
    $Button3.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left)
    $Button3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]690))
    $Button3.Name = [System.String]'Button3'
    $Button3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]45))
    $Button3.TabIndex = [System.Int32]4
    $Button3.Text = [System.String]'Uninstall Selected'
    $Button3.UseCompatibleTextRendering = $true
    $Button3.UseVisualStyleBackColor = $true
    $Button3.add_Click($Button3_Click)
    #
    #Button4
    #
    $Button4.Anchor = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right)
    $Button4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]303,[System.Int32]690))
    $Button4.Name = [System.String]'Button4'
    $Button4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]45))
    $Button4.TabIndex = [System.Int32]5
    $Button4.Text = [System.String]'Uninstall ALL'
    $Button4.UseCompatibleTextRendering = $true
    $Button4.UseVisualStyleBackColor = $true
    $Button4.add_Click($Button4_Click)
    #
    #Form1
    #
    $Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]567,[System.Int32]776))
    $Form1.Controls.Add($Button4)
    $Form1.Controls.Add($Button3)
    $Form1.Controls.Add($Button2)
    $Form1.Controls.Add($Button1)
    $Form1.Controls.Add($ListView1)
    $Form1.Controls.Add($ProgressBar1)
    $Form1.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::SizableToolWindow
    $Form1.MinimumSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]555,[System.Int32]700))
    $Form1.Text = [System.String]'RSAT Installer'
    $Form1.add_Load($Form1_Load)
    $Form1.ResumeLayout($false)
    $Form1.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    Add-Member -InputObject $Form1 -Name base -Value $base -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name ProgressBar1 -Value $ProgressBar1 -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name ListView1 -Value $ListView1 -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name Button1 -Value $Button1 -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name Button2 -Value $Button2 -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name Button3 -Value $Button3 -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name Button4 -Value $Button4 -MemberType NoteProperty

    ### CUSTOM ###
    $ColumnHeader1 = New-Object System.Windows.Forms.ColumnHeader
    $ColumnHeader2 = New-Object System.Windows.Forms.ColumnHeader
    $ColumnHeader3 = New-Object System.Windows.Forms.ColumnHeader
    $ColumnHeader4 = New-Object System.Windows.Forms.ColumnHeader

    $ColumnHeader1.Text = "Name"
    $ColumnHeader2.Text = "Version"
    $ColumnHeader3.Text = "Download"
    $ColumnHeader4.Text = "Install"

    $ListViewGroup11 = New-Object System.Windows.Forms.ListViewGroup("Installed", [System.Windows.Forms.HorizontalAlignment]::Left)
    $ListViewGroup11.Header = "Installed"

    $ListViewGroup12 = New-Object System.Windows.Forms.ListViewGroup("Not Installed", [System.Windows.Forms.HorizontalAlignment]::Left)
    $ListViewGroup12.Header = "Not Installed"

    $ListView1.Columns.AddRange([System.Windows.Forms.ColumnHeader[]](@($ColumnHeader1, $ColumnHeader2, $ColumnHeader3, $ColumnHeader4)))
    $ListView1.Groups.AddRange([System.Windows.Forms.ListViewGroup[]](@($ListViewGroup11, $ListViewGroup12)))
}
. InitializeComponent

$Form1.ShowDialog()