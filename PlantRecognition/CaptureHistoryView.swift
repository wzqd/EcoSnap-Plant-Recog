//
//  PhotoHistoryView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/25.
//

import Foundation
import SwiftUI
import SwiftData


struct CaptureHistoryView: View{
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CaptureItem.captureDate) private var captureItems: [CaptureItem]
    
    
    var body: some View{
//        Text("\(captureItems.count)")
        NavigationStack{
            Group{
                if(captureItems.isEmpty){
                    ContentUnavailableView("Please Capture Some Plants",
                    systemImage: "camera.aperture")
                }
                else{
                    List{
                        ForEach(captureItems){ item in
                            NavigationLink{
                                Text(item.plantItem?.plantName ?? "unkown plant")
                            } label:{
                                HStack(spacing: 10){
                                    VStack(alignment: .leading){
                                        Text(item.captureDate.formatted(date: .abbreviated, time: .complete))
                                    }
                                }
                            }
                            
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let item = captureItems[index]
                                modelContext.delete(item)
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Capture History")
            .padding()
                
        }
    }
}

#Preview {
    CaptureHistoryView()
        .modelContainer(for: CaptureItem.self, inMemory: true)
}
