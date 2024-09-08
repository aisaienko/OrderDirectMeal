//
//  ProductItem.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/7/24.
//

import Foundation
import SwiftData

@Model
final class ProductItem: Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let amount: String
    let mealIndex: Int
    var categoryItem: CategoryItem?
    
    init(name: String, price: Double, mealIndex: Int, amount: String = "") {
        self.id = UUID()
        self.name = name
        self.price = price
        self.mealIndex = mealIndex
        self.amount = amount
    }
}
