//
//  PlantDetailView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/25.



import Foundation
import SwiftUI
import SwiftData


struct PlantDetailView: View{
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @StateObject var recognitionHandler = RecogniationHandler()
    
    @State var selectedTab:Int
    
    @Binding var captureImageData:Data?
    @State var plant: PlantItem?
    
    
    

    
    var body: some View{
        VStack{
            Spacer()
            
            Text("Plant Details")
                .frame(width: 400,height: 50, alignment:.topLeading)
                .font(.largeTitle)
                .fontWeight(.bold)

            
            if self.recognitionHandler.isLoading == true{
                ScrollView{
                    ProgressView()
                }
                
            }
            else{
                if !recognitionHandler.isPlant{
                    ScrollView{
                        Text("This is Not A Plant")
                    }
                }
                else{
                    ScrollView{
                        Text("Taxonomic Name: \(recognitionHandler.plantName)")
                        if (recognitionHandler.hasCommonName){
                            Text("Plant Common Name: \(recognitionHandler.plantCommonName)")
                        }
                        
                    }
                    
                    HStack{
                        Button{
                            dismiss()
                        }label: {
                            Text("Discard Photo")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 175)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        Button{
                            //save history entry, plant entry and update unlock
                            selectedTab = 4
                            if let imageData = captureImageData{
                                let history = CaptureItem(captureDate: Date.now, captureImage: imageData)
                                //                        let plant = PlantItem(plantName: "plant1", scientificName: "sldfkjaf", plantDescription: "this is a plant", captureLocation: "here", plantImageURLs: ["1","2"])
                                //                        history.plantItem = plant
                                
                                modelContext.insert(history)
                                
                            }
                            
                            
                            dismiss()
                        }label: {
                            Text("Save to History")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 175)
                                .background(Color.blue)
                                .cornerRadius(10)
                            
                        }
                    }
                }
            }
                

        }
        .onAppear(){
            DispatchQueue.main.async {
                if let imageData = captureImageData{
                    self.recognitionHandler.recognizePlant(imageData: imageData)
                }else{
                    print("no image data")
                    return
                }
            }

        }
        

        
    }
    
    
}



//#Preview {
////    PlantDetailView()
////        .modelContainer(for: Plant.self, inMemory: true)
//}
