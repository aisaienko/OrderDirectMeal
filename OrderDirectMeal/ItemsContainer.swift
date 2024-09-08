//
//  File.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Order.self, SettingsItem.self, CategoryItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            let categories = MealItemsJSONDecoder.decode(from: "DefaultMealsList")
            if categories.isEmpty == false {
                categories.forEach { categoryItem in
                    let category = CategoryItem(name: categoryItem.name, index: categoryItem.index)
                    container.mainContext.insert(category)
                    categoryItem.mealItems.forEach {mealItem in
                        let item = ProductItem(name: mealItem.name, price: mealItem.price, mealIndex: mealItem.mealIndex, amount: mealItem.amount)
                        category.productItems.append(item)
                    }
                    try? container.mainContext.save()
                }
            }
            let settings = SettingsItem(messageHeader: "", messageFooter: "")
            container.mainContext.insert(settings)
            shouldCreateDefaults = false
        }
        return container
    }
}
