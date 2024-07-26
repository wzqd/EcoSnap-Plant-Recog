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
    var captureDate: Date
    var captureImage: Data
    
    var plantItem: Plant? = nil
    
    init(captureDate: Date = Date.now, captureImage: Data) {
        self.captureDate = captureDate
        self.captureImage = captureImage
    }
}

@Model
class HandbookItem{
    var unlockStatus: Bool = false
    var unlockImageName: String? = nil
    var plantItem: Plant? = nil
    
    init(unlockStatus: Bool, unlockImageName: String? = nil) {
        self.unlockStatus = unlockStatus
        self.unlockImageName = unlockImageName
    }
    
    
}

@Model
class Plant{
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
    
    var captureItem: CaptureItem?
    var handbookItem: HandbookItem?
    
}
