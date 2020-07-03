<#
Pre-reqs:
    The 'AzureRM' PowerShell module
    Install-Module AzureRM
#>



# Conect Azure
    Connect-AzureRmAccount



#Variables
    $contenedor = "lvl48xvision"
    $resource_group = "VISION_LVL01"
    $StorageAccount = Get-AzureRmStorageAccount -Name $contenedor -ResourceGroupName $resource_group



# LIST
    Get-AzureStorageContainer -Context $StorageAccount.Context

    #listar un único blob
    Get-AzureStorageBlob -Container $contenedor -Blob 000/012/A1C0000125354.jpg -Context $StorageAccount.Context

    #listar todos los blobs de un producto (mismo código)
    $lista_blobs_proyecto=Get-AzureStorageBlob -Container $contenedor -Blob 000/012/*0000125354.jpg -Context $StorageAccount.Context




# CAMBIAR TIER
    
    #desarchivar un blob
    $blob_desarchivar = Get-AzureStorageBlob -Container $contenedor -Blob 000/012/A1C0000120000.jpg -Context $StorageAccount.Context
    $blob_desarchivar.ICloudBlob.SetStandardBlobTier("Cool")

    #desarchivar varios blob
    $blobs_desarchivar = Get-AzureStorageBlob -Container $contenedor -Blob 000/012/*0000120000.jpg -Context $StorageAccount.Context
    $blobs_desarchivar.ICloudBlob.SetStandardBlobTier("Cool")

    #archivar un blob
    $blob_a_enfriar=Get-AzureStorageBlob -Container $contenedor -Blob 000/012/A1C0000120000.jpg -Context $StorageAccount.Context
    $blob_a_enfriar.ICloudBlob.SetStandardBlobTier("Archive")



# DOWNLOAD

    # Download un único blob
    Get-AzureStorageBlobContent -Container $contenedor -Blob 000/012/A1C0000125354.jpg -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context
    
    # Download de los blobs de un proyecto
    $lista_blobs_proyecto | %{
        Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context
    }




# DELETE a blob

    Remove-AzureStorageBlob -Container $contenedor -Blob "archivo_a_borrar.pdf" -Context $StorageAccount.Context

    Get-AzureStorageBlob -Container $contenedor -Blob * -Context $StorageAccount.Context | Remove-AzureStorageBlob





# UPLOAD blobs

    Set-AzureStorageBlobContent -Container $contenedor -Blob archivo_a_subir.pdf -File C:\Blobs\archivo_a_subir.pdf -Context $StorageAccount.Context 

    Get-ChildItem C:\Blobs | Set-AzureStorageBlobContent -Container $contenedor -Context $StorageAccount.Context -Force




# COPY blobs between Containers

    Get-AzureStorageContainer -Context $StorageAccount.Context | Get-AzureStorageBlob -Context $StorageAccount.Context

    Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob ipswitch.iso -DestContainer iso02 -DestBlob ipswitch.iso -Context $StorageAccount.Context

    Get-AzureStorageBlob -Container iso -Blob "*.iso" -Context $StorageAccount.Context | Start-AzureStorageBlobCopy -DestContainer iso02

    Get-AzureStorageBlobCopyState -Blob "Windows10_x64.iso" -Container "iso02" -Context $StorageAccount.Context




# RENAME a blob

    Get-AzureStorageBlob -Container "iso" -Blob * -Context $StorageAccount.Context

    Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob Windows10_x64.iso  -DestContainer iso -DestBlob Windows10_x64_NUEVO.iso  -Context $StorageAccount.Context

    Remove-AzureStorageBlob -Container "iso" -Blob "Windows10_x64.iso" -Context $StorageAccount.Context




# MAKE SNAPSHOT of a blob

    $ReadmeBlob = Get-AzureStorageBlob -Container $contenedor -Blob archivo.txt -Context $StorageAccount.Context

    $ReadmeBlob.ICloudBlob.CreateSnapshot()

    $snapshots = Get-AzureStorageBlob -Container $contenedor -prefix archivo.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}




# RESTORE SNAPSHOT a snapshot

    Get-AzureStorageBlob -Container docs -Blob archivo.txt -Context $StorageAccount.Context

    $snapshots = Get-AzureStorageBlob -Container docs -prefix archivo.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

    $snapshots | Out-GridView -PassThru | Start-AzureStorageBlobCopy -DestContainer docs -Force




# DELETE SNAPSHOT 

    $snapshots = Get-AzureStorageBlob -Container docs -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

    $snapshots | Remove-AzureStorageBlob
