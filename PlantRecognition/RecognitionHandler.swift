//
//  RecognitionHandler.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/8/1.
//

import Foundation
import SwiftUI
import SwiftData


class RecognitionHandler: ObservableObject{
    @Published var isLoading = false
    
    @Published var plantName: String = ""
    @Published var isPlant: Bool = false
    @Published var hasCommonName: Bool = false
    @Published var plantCommonName: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    
    func recognizePlant(imageData: Data){
        isLoading = true
        print(isLoading)
        
        
        let parameters:[String: Any] = [
            "api_key": "SMEkJHGspUYvZ36PW2ZAd4S17tsoiWphZfJnWH9WAkSp8LkgHu",
            "images": [imageData.base64EncodedString()],
            "plant_language": "en",
            "plant_details": ["common_names"]
        ]
       
        
        var request = URLRequest(url: URL(string: "https://plant.id/api/v2/identify")!,timeoutInterval: 60)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        

        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            guard let data = data else {
                print("error generated")
                print(String(describing: error))
                return
            }
            
            var result: PlantResult?
            
            print(String(data: data, encoding: .utf8)!)
            
            
            do{
                result = try JSONDecoder().decode(PlantResult.self, from: data)
                
                
            }
            catch{
                print("decode error")
                print("\(error)")
            }
            
            guard let json = result else{return}
            
            DispatchQueue.main.async {
                print("print data")
                print(json.is_plant)
                self.isPlant = json.is_plant
                
                print(json.suggestions[0].plant_name)
                self.plantName = json.suggestions[0].plant_name
                
                if !json.suggestions[0].plant_details.common_names!.isEmpty{
                    print(json.suggestions[0].plant_details.common_names![0])
                    self.hasCommonName = true
                    self.plantCommonName = json.suggestions[0].plant_details.common_names![0]
                    
                }
                
                
                
                
                
                self.isLoading = false
                print(self.isLoading)
            }
            
            

        }
        
        task.resume()
        
        
    }
}



struct PlantResult: Codable{
    var is_plant:Bool
    var suggestions:[Suggestions]

}

struct Suggestions:Codable{
    var id:Int
    var plant_name:String
    var plant_details:PlantDetails
}

struct PlantDetails:Codable{
    var common_names:[String]?
}

