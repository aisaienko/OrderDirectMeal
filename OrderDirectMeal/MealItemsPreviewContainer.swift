//
//  MealItemsPreviewContainer.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let schema = Schema([Order.self, SettingsItem.self, CategoryItem.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    let order = Order()
    container.mainContext.insert(order)
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
    order.timestamp = .now
    let item = OrderItem(name: "Куриная Грудка", amount: "+- 2lb", price: 1.5, mealIndex: 25, quantity: 1)
    order.orderItems.append(item)
    order.units += 1.5
    order.generateMessage()
    try? container.mainContext.save()
    let settings = SettingsItem(messageHeader: "Test header message", messageFooter: "Test footer message")
    container.mainContext.insert(settings)
    
    return container
}()
