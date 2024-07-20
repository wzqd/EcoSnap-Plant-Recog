//
//  PhotoManager.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/20.
//

import Foundation
import Photos
import AVFoundation

class PhotoManager:NSObject, ObservableObject{
    
    private var assetCollection: PHAssetCollection?
    
    var smartAlbumType: PHAssetCollectionSubtype?
    
    //Get album in photo library
    private static func getSmartAlbum(subtype: PHAssetCollectionSubtype) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: fetchOptions)
        return collections.firstObject
    }
    
    
    
    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        
        self.smartAlbumType = smartAlbumType
        
        
        if let assetCollection = PhotoManager.getSmartAlbum(subtype: smartAlbumType) {
            self.assetCollection = assetCollection
        }
        
        super.init()
    }
    
    
    
    /// save image to photo library
    /// - Parameter photo: ACCapturePhoto data type from AVCaptureSession
    func saveImage(_ photo: AVCapturePhoto)  {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        guard let assetCollection = self.assetCollection else {
            return
        }
        
             PHPhotoLibrary.shared().performChanges {
                
                let creationRequest = PHAssetCreationRequest.forAsset()
                if let assetPlaceholder = creationRequest.placeholderForCreatedAsset {
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                    
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection), assetCollection.canPerform(.addContent) {
                        let fastEnumeration = NSArray(array: [assetPlaceholder])
                        albumChangeRequest.addAssets(fastEnumeration)
                    }
                }
            }
    }
    
}
