//
//  PhotoHistoryView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/25.
//

import Foundation
import SwiftUI
import SwiftData
import CoreLocation

struct CaptureHistoryView: View{
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CaptureItem.captureDate) private var captureItems: [CaptureItem]
    
    @State private var snapshotImage: UIImage? = nil
    
    
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
                                if let uiImage = UIImage(data: item.captureImage) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding()
                                }
                                
                                Text(item.plantItem?.plantName ?? "This is an Unkown Plant")
                                Text(item.plantItem?.scientificName ?? "Unkown scientific name")
                                
                                
                                Text("Plant Location:")
                                    .font(.headline)
                                
                                if let laString = item.plantItem?.captureLocation.components(separatedBy: ",")[0],
                                   let lonString = item.plantItem?.captureLocation.components(separatedBy: ",")[1]{
                                    if let la = Double(laString),
                                    let lon = Double(lonString){
                                            MapSnapshotView(location:   CLLocationCoordinate2D(latitude: la, longitude: lon))
                                        }
                                        
                                    
                                }

                                
//                                Text(item.plantItem?.plantDescription ?? "unkown description")
//                                Text(item.plantItem?.plantImageURLs[0] ?? "random url")
                            } label:{
                                HStack(spacing: 10){
                                    //turn data into image
                                    if let uiImage = UIImage(data: item.captureImage) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 75, height: 75, alignment: .leading)
                                            .clipShape(Circle())
                                    } else {
                                        Text("Image not available")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10){
                                        Text(item.captureDate.formatted(date: .abbreviated, time: .shortened))
                                    }
                                    
                                }
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
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
