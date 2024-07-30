//
//  ContentView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/6.
//

import SwiftUI
import HealthKit
import Charts

struct ContentView: View {
    @State var isLoading = false
    
    @State var selectedTab:Int = 0
    
    var body: some View {
        
        ZStack {
            
            TabView(selection: $selectedTab) {
                stepsView()
                    .tabItem {
                        Text("Home")
                        Image(systemName: "house.fill")
                    }.tag(1)
                
                CameraView()
                    .tabItem {
                        
                        Text("Recognize")
                            .ignoresSafeArea(edges: .all)
                        Image(systemName: "camera.fill")
                            .ignoresSafeArea(edges: .all)
                    }.tag(2)
                CaptureHistoryView()
                    .tabItem {
                        Text("History")
                            .ignoresSafeArea(edges: .all)
                        Image(systemName: "book.fill")
                            .ignoresSafeArea(edges:.all)
                    }.tag(3)
            }
            .ignoresSafeArea(edges: .all)
            
            if isLoading{
                InitView()
            }
            
        }
        .ignoresSafeArea(edges:.all)
        .onAppear{self.loadInitView()}
        
    }
    
    func loadInitView(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            isLoading = false
        }
    }
    
}


struct InitView:View{
    var body: some View{
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack{
                Text("Plant Recognition")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
                    .padding()
            }
            

        }
    }
}




#Preview {
   
    ContentView()
}
