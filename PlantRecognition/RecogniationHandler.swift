//
//  RecogniationHandler.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/8/1.
//

import Foundation
import SwiftUI


class RecogniationHandler{
    func recognizePlant(imageData: Data){
        
        
        let parameters:[String: Any] = [
            "api_key": "SMEkJHGspUYvZ36PW2ZAd4S17tsoiWphZfJnWH9WAkSp8LkgHu",
            "images": [imageData.base64EncodedString()],
            "plant_language": "en",
            "plant_details": ["common_names"]
        ]
       
        
       
//        let parameters = "{\n    \"images\": [\(imageData.base64EncodedString())],\n    \"similar_images\": true\n}"
//        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://plant.id/api/v2/identify")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            print("print data")
            print(json.is_plant)
            print(json.suggestions[0].plant_name)
            print(json.suggestions[0].plant_details[0].common_names[0])
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
    var plant_details:[PlantDetails]
}

struct PlantDetails:Codable{
    var common_names:[String]
}

