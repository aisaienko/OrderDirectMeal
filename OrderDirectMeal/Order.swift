//
//  Order.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import Foundation
import SwiftData

@Model
final class Order: ObservableObject, Identifiable {
    var id: String
    var timestamp: Date
    var units: Double
    var orderMessage: String
    
    @Relationship(deleteRule: .cascade, inverse: \OrderItem.order)
    var orderItems: Array<OrderItem> = []
    
    init(timestamp: Date = .now, units: Double = 0, orderMessage: String = "") {
        self.id = UUID().uuidString
        self.timestamp = timestamp
        self.units = units
        self.orderMessage = orderMessage
    }
    
    func generateMessage(messageHeader: String = "", messageFooter: String = "") {
        var resultText: String = messageHeader
        self.orderItems.sorted(by: {
            return $0.mealIndex < $1.mealIndex
        }).forEach { orderItem in
            var orderLine = String(orderItem.mealIndex) + ". " + orderItem.name
            if orderItem.quantity > 1 {
                orderLine += " (x" + String(orderItem.quantity) + ")"
            }
            resultText += orderLine + "\n"
        }
        resultText += messageFooter
        self.orderMessage = resultText
    }
}
