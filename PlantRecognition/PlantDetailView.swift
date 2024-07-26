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
    
    @State var plant: Plant?
    
    var body: some View{
        VStack{
            Spacer()
            
            Text("Plant Details")
                .frame(width: 350,height: .infinity, alignment:.topLeading)
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



#Preview {
    PlantDetailView()
        .modelContainer(for: Plant.self, inMemory: true)
}
