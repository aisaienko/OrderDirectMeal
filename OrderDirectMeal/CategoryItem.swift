//
//  CategoryItem.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/7/24.
//

import Foundation
import SwiftData

@Model
final class CategoryItem: Identifiable {
    let id: UUID
    let index: Int
    let name: String
    @Relationship(deleteRule: .cascade, inverse: \ProductItem.categoryItem)
    var productItems: [ProductItem] = []
    
    init(name: String, index: Int) {
        self.id = UUID()
        self.name = name
        self.index = index
    }
}
