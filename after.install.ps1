# Jean Roloff <roloff.jean@gmail.com>

# Execution Policy
Set-ExecutionPolicy RemoteSigned -Force

# disable ipv6
Import-Module NetAdapter -Force
Set-NetAdapterBinding -Name * -ComponentID "ms_tcpip6" -Enabled:$false

# padrão pt-br
Set-WinUserLanguageList -LanguageList pt-BR -Force

# oculta tipos de arquivos conhecidos
$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty $key HideFileExt 0

# lixeira : configurar para não perguntarao excluir arquivo
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$propertyName = "ConfirmFileDelete"

if (-not (Get-Item -Path $path -ErrorAction SilentlyContinue)) { New-Item -Path $path }
if (-not (Get-ItemProperty -Path $path -Name $propertyName -ErrorAction SilentlyContinue)) {
    $type = [Microsoft.Win32.RegistryValueKind]::DWord
    New-ItemProperty -Path $path -Name $propertyName -PropertyType $type
}
Set-ItemProperty -Path $path -Name $propertyName -Value 0

# Restart Explorer
Stop-Process -processname Explorer

# Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation

# svn
choco install svn -y

# tortoisesvn
choco install tortoisesvn -y

# git
choco install git -y

# browser : firefox
choco install firefox -y

# browser : chrome
choco install googlechrome -y

# 7zip
choco install 7zip -y

# Skype
choco install skype -y

# Java Runtime
choco install javaruntime -y

# Adobe Reader
choco install adobereader -y

# Notepad++
choco install notepadplusplus -y

# Habilita Hiver-V
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -All 