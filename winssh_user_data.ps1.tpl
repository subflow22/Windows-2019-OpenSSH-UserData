<powershell>
$keys = @("${key}")
function setPerms($path)
    {
        $acl = New-Object System.Security.AccessControl.DirectorySecurity
        $dacl = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl","Allow")
        $acl.SetAccessRule($dacl)
        $dacl = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrator","ReadAndExecute","Allow")
        $acl.SetAccessRule($dacl)
        $acl.SetAccessRuleProtection($true,$false)
        $acl | Set-Acl $path
    }
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Set-Service -Name ssh-agent -StartupType "Automatic"
Set-Service -Name sshd -StartupType "Automatic"
Start-Service ssh-agent
Start-Service sshd
mkdir ~\.ssh\
cd ~\.ssh\
Start-Process ssh-keygen -WorkingDirectory "~\.ssh" -ArgumentList '-b 2048 -t rsa -f id_rsa -q -N ""'
$ErrorActionPreference = 'SilentlyContinue'
ssh-add id_rsa
$ErrorActionPreference = 'Continue'
$keys.ForEach({$_ | Out-File -Encoding utf8 -FilePath C:\Users\Administrator\.ssh\authorized_keys -Append -Force})
$dirs = ("C:\Users\Administrator\.ssh\authorized_keys","C:\Users\Administrator\.ssh\id_rsa")
$dirs.ForEach({setPerms($_)})
Remove-Item C:\ProgramData\ssh\sshd_config -Force
$1 = "PasswordAuthentication	no"
$2 = "PermitRootLogin	yes"
$3 = "AuthorizedKeysFile	.ssh/authorized_keys"
$4 = "Subsystem	sftp	sftp-server.exe"
$config = ($1,$2,$3,$4)
$config.ForEach({$_ | Out-File -Encoding utf8 -FilePath C:\ProgramData\ssh\sshd_config -Force})
Restart-Service sshd
&netsh advfirewall firewall add rule name="SSH" protocol=TCP localport=22 dir=in action=allow profile=public,private,domain enable=yes
</powershell>