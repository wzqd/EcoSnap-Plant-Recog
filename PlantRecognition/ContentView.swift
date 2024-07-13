//
//  ContentView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/6.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    private let healthStore = HKHealthStore()
    
    @StateObject var healthKitManager = HealthKitManager.Instance
    
    var body: some View {
        
        
        healthKitManager.getDailyStepCount() { steps in // This function gets the daily step count of the users.
            DispatchQueue.main.async {
                    print("Step count is:", steps)
            }
        }
        healthKitManager.getWeeklyStepCount() { steps in // This function gets the weekly step count of the users.
            DispatchQueue.main.async {
                for i in 1...7{
                    print("Day",i ,"Step count is:", steps[i]!)
                }
                        
            }
        }
        
        
        return VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
}

#Preview {
   
    ContentView()
}
