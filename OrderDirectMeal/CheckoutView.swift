//
//  CheckoutView.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI
import SwiftData

struct CheckoutView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var basket: Basket
    @State private var order = Order()
    
    @Query var settings: [SettingsItem]
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(basket.categories) { category in
                        Section(isExpanded: Binding<Bool> (
                            get: {
                                return basket.isExpanded.contains(category.id)
                            },
                            set: { isExpanding in
                                if isExpanding {
                                    basket.isExpanded.insert(category.id)
                                } else {
                                    basket.isExpanded.remove(category.id)
                                }
                            })) {
                                ForEach(category.products) { product in
                                    HStack {
                                        ProductLineItemView(product: product,
                                                            onIncrement: {
                                            category.totalPrice += product.price
                                            basket.totalUnits += product.price
                                        },
                                                            onDecrement: {
                                            category.totalPrice -= category.totalPrice >= product.price ? product.price : 0
                                            basket.totalUnits -= basket.totalUnits >= product.price ? product.price : 0
                                        })
                                    }
                                    .listRowBackground(product.quantity > 0 ? Color.green.opacity(0.2) : Color.clear)
                                }
                            } header: {
                                HStack(spacing: 20) {
                                    Text(category.name)
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                    if category.totalPrice > 0 {
                                        Text("(Units: " + String(category.totalPrice) + ")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                            }
                    }
                }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem (placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Label("Back", systemImage: "chevron.backward")
                            })
                        }
                        ToolbarItem (placement: .principal) {
                            Text("Total Units: " + String(basket.totalUnits)).font(.title2)
                        }
                        ToolbarItem (placement: .navigationBarTrailing) {
                            Button(action: {
                                withAnimation {
                                    modelContext.insert(order)
                                    settings.forEach { settingItem in
                                        basket.updateOrder(order: order, settings: settingItem)
                                    }
                                    copyToClipboard()
                                    try? modelContext.save()
                                }
                                dismiss()
                            }, label: {
                                Label("Save", systemImage: "doc.on.doc.fill")
                                    .labelStyle(.titleAndIcon)
                            })
                        }
                    }
                    .listStyle(.sidebar)
                }
            }
        }
        
    
    func copyToClipboard() {
        pasteboard.string = self.order.orderMessage
    }
}

#Preview {
    struct Container: View {
        let previewBasket: Basket = Basket()
        var body: some View {
            CheckoutView(basket: previewBasket)
        }
    }
    return Container().modelContainer(previewContainer)
}
