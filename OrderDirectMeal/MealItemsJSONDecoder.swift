//
//  MealItemsJSONDecoder.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import Foundation

struct MealItemsResponse: Decodable {
    let name: String
    let price: Double
    let amount: String
    let mealIndex: Int
}

struct MealCategoriesResponse: Decodable {
    let name: String
    let index: Int
    let mealItems: [MealItemsResponse]
}



struct MealItemsJSONDecoder {
    
    static func decode(from fileName: String) -> [MealCategoriesResponse] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let mealCategories = try? JSONDecoder().decode([MealCategoriesResponse].self, from: data) else {
            return []
        }
        
        return mealCategories
    }
    
    static func decodeFromUrl(urlPath: String, completion:@escaping ([MealCategoriesResponse]?) -> ()) {
        let menuUrl = URL(string: urlPath)!
        URLSession.shared.dataTask(with: menuUrl) { data,_,_  in
            let menu = try? JSONDecoder().decode([MealCategoriesResponse].self, from: data!)
            
            DispatchQueue.main.async {
                completion(menu)
            }
        }
        .resume()
    }
}
