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
#endregion



# DOWNLOAD

    # Download un único blob
    Get-AzureStorageBlobContent -Container $contenedor -Blob 000/012/A1C0000125354.jpg -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context
    
    # Download de los blobs de un proyecto
    $lista_blobs_proyecto | %{
        Get-AzureStorageBlobContent -Container $contenedor -Blob $_.Name -Destination "C:\blobs_recuperados\" -Context $StorageAccount.Context
    }
#endregion




# DELETE a blob

    Remove-AzureStorageBlob -Container "docs" -Blob "DS-Ipswitch-Analytics.pdf" -Context $StorageAccount.Context

    Get-AzureStorageBlob -Container "docs" -Blob * -Context $StorageAccount.Context | Remove-AzureStorageBlob

#endregion




# UPLOAD blobs

    Set-AzureStorageBlobContent -Container "docs" -Blob DS-Ipswitch-Analytics.pdf -File C:\Blobs\DS-Ipswitch-Analytics.pdf -Context $StorageAccount.Context 

    Get-ChildItem C:\Blobs | Set-AzureStorageBlobContent -Container "docs" -Context $StorageAccount.Context -Force

#endregion




# COPY blobs between Containers

    Get-AzureStorageContainer -Context $StorageAccount.Context | Get-AzureStorageBlob -Context $StorageAccount.Context

    Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob ipswitch.iso -DestContainer iso02 -DestBlob ipswitch.iso -Context $StorageAccount.Context

    Get-AzureStorageBlob -Container iso -Blob "*.iso" -Context $StorageAccount.Context | Start-AzureStorageBlobCopy -DestContainer iso02

    Get-AzureStorageBlobCopyState -Blob "Windows10_x64.iso" -Container "iso02" -Context $StorageAccount.Context

#endregion




# RENAME a blob

    Get-AzureStorageBlob -Container "iso" -Blob * -Context $StorageAccount.Context

    Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob Windows10_x64.iso  -DestContainer iso -DestBlob Windows10_x64_002.iso  -Context $StorageAccount.Context

    Remove-AzureStorageBlob -Container "iso" -Blob "Windows10_x64.iso" -Context $StorageAccount.Context

#endregion




# MAKE SNAPSHOT of a blob

    $ReadmeBlob = Get-AzureStorageBlob -Container docs -Blob Readme.txt -Context $StorageAccount.Context

    $ReadmeBlob.ICloudBlob.CreateSnapshot()

    $snapshots = Get-AzureStorageBlob -Container docs -prefix Readme.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

#endregion




# RESTORE SNAPSHOT a snapshot

    Get-AzureStorageBlob -Container docs -Blob Readme.txt -Context $StorageAccount.Context

    $snapshots = Get-AzureStorageBlob -Container docs -prefix Readme.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

    $snapshots | Out-GridView -PassThru | Start-AzureStorageBlobCopy -DestContainer docs -Force

#endregion




# DELETE SNAPSHOT 

    $snapshots = Get-AzureStorageBlob -Container docs -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

    $snapshots | Remove-AzureStorageBlob

#endregion