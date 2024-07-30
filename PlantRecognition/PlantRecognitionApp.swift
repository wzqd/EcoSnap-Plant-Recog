//
//  PlantRecognitionApp.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/6.
//

import SwiftUI
import SwiftData

@main
struct PlantRecognitionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
//            CameraView()
//            CaptureHistoryView()
        }
        .modelContainer(for: PlantItem.self)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
