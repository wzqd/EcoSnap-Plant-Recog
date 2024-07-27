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
    
    @Binding var captureImageData:Data?
    @State var plant: Plant?
    
    var body: some View{
        VStack{
            Spacer()
            
            Text("Plant Details")
                .frame(width: 400,height: 50, alignment:.topLeading)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
            ScrollView{
                Text("Plant descriptions")
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
                    if let imageData = captureImageData{
                        let history = CaptureItem(captureDate: Date.now, captureImage: imageData)
                        modelContext.insert(history)
                    }
                    else{
                        print("Data not prepared")
                        let history = CaptureItem(captureDate: Date.now, captureImage: Data())
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



//#Preview {
////    PlantDetailView()
////        .modelContainer(for: Plant.self, inMemory: true)
//}
