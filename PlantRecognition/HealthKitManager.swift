//
//  File.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/13.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
  static let Instance = HealthKitManager()

  var healthStore = HKHealthStore()

//  var stepCountToday: Int = 0
//  var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0,
//                                   4: 0, 5: 0, 6: 0, 7: 0]

    
    init() {
        authorizeHealthKit()
    }


    func authorizeHealthKit() {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ] // We want to access the step count.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in  // We will check the authorization.
            if success {}
            else{
                print("\(String(describing: error))")
            }
        }
    }
    
    public func getDailyStepCount(afterCompletion: @escaping (Int) -> Void){
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {return}

        let now = Date()  //end time
        let startDate = Calendar.current.startOfDay(for: now) //start time
        let predicate = HKQuery.predicateForSamples(
              withStart: startDate,
              end: now,
              options: .strictStartDate) //query predicate

        let query = HKStatisticsQuery(
              quantityType: stepCountType,
              quantitySamplePredicate: predicate,
              options: .cumulativeSum)
        { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            
            afterCompletion(steps)
            
//            DispatchQueue.main.async {
////                self.stepCountToday = steps
//                afterCompletion(steps) // Return the step count.
//            }
        }
        
        healthStore.execute(query)
    }
    
    
}
