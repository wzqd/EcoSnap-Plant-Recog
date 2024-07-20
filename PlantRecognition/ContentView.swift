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
    
    @StateObject static var healthKitManager = HealthKitManager.Instance
    
    var body: some View {
        

        ZStack {
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
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
            }
            .ignoresSafeArea(edges: .all)
            
            Rectangle() //border line
                .fill(Color.gray)
                .frame(height: 3)
                .edgesIgnoringSafeArea(.horizontal) // Extend the line horizontally
                .offset(y:341) // Adjust the offset to position the line above the tabs
        }
        .ignoresSafeArea(edges:.all)
        
            
    }
    
}

struct stepsView: View{
    @ObservedObject  var healthKitManager = HealthKitManager.Instance
    
    let weekDays = ["","Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init(){
        healthKitManager.authorizeHealthKit()
        healthKitManager.getDailyStepCount()
        healthKitManager.getWeeklyStepCount()
    }
    
    var body: some View{
        VStack {
            Spacer()
            
            ZStack{
                Circle()
                    .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))]),
                        startPoint: .top,
                        endPoint: .trailing))
                    .frame(width: 200)
                
                VStack {
                    Text("Daily Steps")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("\(healthKitManager.dailyStepCount)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                
               
                        
            }
                
            
            Spacer()
            
            Text("Weekly Steps")
                .font(.headline)
            Chart {
                    ForEach(healthKitManager.weeklyStepCount.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        BarMark(
                            x: .value("WeekDay",weekDays[key]),
                            y: .value("Value", value)
                        )
                    }
                }
                .frame(height: 200)
                .padding()
            Spacer()
            
            }
            
    }
}

#Preview {
   
    ContentView()
}
