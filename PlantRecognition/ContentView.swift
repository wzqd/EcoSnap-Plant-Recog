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
        
        
        healthKitManager.getDailyStepCount() { steps in // This function provides to get the step count of the users.
                    DispatchQueue.main.async {
                        print("Step count is:", steps) // Get the step count.
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
