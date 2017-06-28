# leva em conta que já tenho a pasta padrão _sofwares no C:\

# apache-cgi
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\_softwares\apache\apache-cgi.zip", "C:\")

# Instala o serviço do Apache
& C:\apache-cgi\bin\Apache24\bin\httpd.exe -k install -n "Apache24Service"

# MySQL
Start-Process "C:\_sofwares\mysql\mysql-5.5.49-winx64.msi" -Wait

# Libera acesso externo ao mysql
netsh advfirewall Firewall add rule name="Mysql Port" localport=3306 protocol=tcp dir=in action=allow
netsh advfirewall Firewall add rule name="Apache Port" localport=80 protocol=tcp dir=in action=allow

# Configurando MySQL
$MyLocation = Get-Location
Push-Location -Path "C:\Program Files\MySQL\MySQL Server 5.5\bin\"
.\mysql --user=root --password=123456 --database=test --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '123456';"
.\mysql --user=root --password=123456 --database=test --execute="UPDATE mysql.user SET Password=PASSWORD('123456') WHERE User='root';"
.\mysql --user=root --password=123456 --database=test --execute="FLUSH PRIVILEGES;"
Push-Location -Path $MyLocation.Path

# Adicionar a config do "file-per-table" para salvar espaço no SSD
$IniDir = "C:\Program Files\MySQL\MySQL Server 5.5\my.ini"
$Has = Select-String -Path $IniDir -Pattern "innodb_file_per_table"
if( $Has -eq $null ) {
    Add-Content $IniDir "`n`n# Configuração de INNODB por arquivo para salvar espaço no SSD"
    Add-Content $IniDir "`ninnodb_file_per_table=1"
}

# Reboot no serviço do MySQL
net stop MySQL
net start MySQL