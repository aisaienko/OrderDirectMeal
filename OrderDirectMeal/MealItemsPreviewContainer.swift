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
    let schema = Schema([Order.self, SettingsItem.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    let order = Order()
    container.mainContext.insert(order)
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
