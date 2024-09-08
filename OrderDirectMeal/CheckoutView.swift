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
                                ForEach(category.products.sorted {
                                    $0.mealIndex < $1.mealIndex
                                }) { product in
                                    HStack {
                                        ProductLineItemView(product: product,
                                                            onIncrement: {
                                            category.updateTotalPrice()
                                            basket.updateTotals()
                                        },
                                                            onDecrement: {
                                            category.updateTotalPrice()
                                            basket.updateTotals()
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
        @Query(
            sort: \CategoryItem.index,
            order: .forward
        ) private var categoryItems: [CategoryItem]
        var body: some View {
            let previewBasket: Basket = Basket(categoryItems: categoryItems)
            CheckoutView(basket: previewBasket)
        }
    }
    return Container().modelContainer(previewContainer)
}
