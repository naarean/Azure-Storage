#1: Desarchivar
    Connect-AzureRmAccount
    $contenedor = "lvl48xvision"
    $resource_group = "VISION_LVL01"
    $StorageAccount = Get-AzureRmStorageAccount -Name $contenedor -ResourceGroupName $resource_group


    #D1
    $ruta_D1 = "000/012/*C0000129485.jpg"
    Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D1 -Context $StorageAccount.Context | FT -AutoSize
    $blobs_desarchivar1 = Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D1 -Context $StorageAccount.Context
    $blobs_desarchivar1.ICloudBlob.SetStandardBlobTier("Cool")

    #D2
    $ruta_D2 = "000/012/*C0000128665.jpg"
    Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D2 -Context $StorageAccount.Context| FT -AutoSize
    $blobs_desarchivar2 = Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D2 -Context $StorageAccount.Context
    $blobs_desarchivar2.ICloudBlob.SetStandardBlobTier("Cool")

    #D3
    $ruta_D3 = "000/009/*C0000090345.jpg"
    Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D3 -Context $StorageAccount.Context| FT -AutoSize
    $blobs_desarchivar3 = Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D3 -Context $StorageAccount.Context
    $blobs_desarchivar3.ICloudBlob.SetStandardBlobTier("Cool")

    #D4
    $ruta_D4 = "000/014/*C0000147462.jpg"
    Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D4 -Context $StorageAccount.Context| FT -AutoSize
    $blobs_desarchivar4 = Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D4 -Context $StorageAccount.Context
    $blobs_desarchivar4.ICloudBlob.SetStandardBlobTier("Cool")

    #D5
    $ruta_D5 = "000/014/*C0000148689.jpg.jpg"
    Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D5 -Context $StorageAccount.Context| FT -AutoSize
    $blobs_desarchivar5 = Get-AzureStorageBlob -Container $contenedor -Blob $ruta_D5 -Context $StorageAccount.Context
    $blobs_desarchivar5.ICloudBlob.SetStandardBlobTier("Cool")


#2: Esperar Archive->Cool
    Start-Sleep -s 21600 #6h


#3:Decargar (-Force para sobreescribir el fichero si existiera)
    $blobs_desarchivar1 | %{ Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context -Force | FT -AutoSize}
    $blobs_desarchivar2 | %{ Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context -Force | FT -AutoSize}
    $blobs_desarchivar3 | %{ Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context -Force | FT -AutoSize}
    $blobs_desarchivar4 | %{ Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context -Force | FT -AutoSize}
    $blobs_desarchivar5 | %{ Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context -Force | FT -AutoSize}
