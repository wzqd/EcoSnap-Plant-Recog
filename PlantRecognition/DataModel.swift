//
//  DataModel.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/25.
//

import Foundation
import SwiftData
import Photos
import CoreImage

@Model
class CaptureItem{
    var captureDate: Date = Date.now
    @Attribute(.externalStorage)
    var captureImage: Data
    
    var plantItem: PlantItem? = nil
    
    init(captureDate: Date = Date.now, captureImage: Data) {
        self.captureDate = captureDate
        self.captureImage = captureImage
    }
}

@Model
class HandbookItem{
    var unlockStatus: Bool = false
    var unlockImageName: String = "plantImage"
    var afterUnlockImageName: String
    var plantItem: PlantItem? = nil
    
    init(unlockStatus: Bool, unlockImageName: String = "plantImage", afterUnlockImageName:String) {
        self.unlockStatus = unlockStatus
        self.unlockImageName = unlockImageName
        self.afterUnlockImageName = afterUnlockImageName
    }
    
    
}

@Model
class PlantItem{
    var plantName: String = ""
    var scientificName: String = ""
    var plantDescription: String = ""
    var captureLocation: String = ""
    var plantImageURLs: [String] = [] //plant iamge from online resource
    
    init(plantName: String, scientificName: String, plantDescription: String, captureLocation: String, plantImageURLs: [String]) {
        self.plantName = plantName
        self.scientificName = scientificName
        self.plantDescription = plantDescription
        self.captureLocation = captureLocation
        self.plantImageURLs = plantImageURLs
    }
    
    var captureItem: [CaptureItem]?
    var handbookItem: HandbookItem?
    
}
