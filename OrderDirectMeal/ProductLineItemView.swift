//
//  ProductLineItemView.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI

struct ProductLineItemView: View {
    
    @StateObject var product: Product
    
    var onIncrement : () -> ()
    var onDecrement : () -> ()
    
    var body: some View {
        HStack(spacing: 5) {
            Text("\(product.mealIndex).").font(.title3)
            VStack(spacing: 10) {
                Text(product.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text(product.amount)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            Text(String(product.price)).font(.title3).padding(10).background(.yellow.opacity(0.4)).clipShape(Circle())
            VStack {
                Text("Qty: **\(product.quantity)**")
                    .font(.callout)
                Stepper("Quantity",
                        onIncrement: {
                    product.quantity += 1
                    onIncrement()
                }, onDecrement: {
                    product.quantity -= (product.quantity >= 1 ? 1 : 0)
                    onDecrement()
                })
            }
        }
        .labelsHidden()
    }
}

#Preview {
    let previewProduct = Product(name: "Куриная Грудка", price: 1.5, mealIndex: 25, amount: "+- 2 lb")
    return ProductLineItemView(product: previewProduct, onIncrement: {}, onDecrement: {})
}
