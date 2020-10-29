# Windows-2019-OpenSSH-UserData
Windows 2019 OpenSSH UserData for EC2.  Provides immediate SSH connectivity for Windows Server instances similar to Linux EC2.  Works with utilities like Packer over SSH.

To use as EC2 user_data, be sure to replace ${key} in line 2 with the key you intend to use to connect to the resulting instance.  Otherwise, if used in Terraform, for example, make sure you pass a 'key' value to teh template to replace ${key}.

Logon is, unfortunately, limited to Administrator.  Great for development, not recommended for production use.
