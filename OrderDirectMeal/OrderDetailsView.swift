//
//  OrderDetailsView.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI
import SwiftData

struct OrderDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var copyButtonText: String = "Copy To Clipboard"
    @State private var showEditOrder = false
    
    @StateObject var order: Order
    private let pasteboard = UIPasteboard.general
    
    @Query(
        sort: \CategoryItem.index,
        order: .forward
    ) private var categoryItems: [CategoryItem]
    
    @Query var settings: [SettingsItem]
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    NavigationLink("Generate Message") {
                        NavigationView {
                            VStack {
                                TextEditor(text: $order.orderMessage)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                                Button(action: {
                                    copyToClipboard()
                                }, label: {
                                    Label(copyButtonText, systemImage: "doc.on.doc.fill")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                })
                            }
                            .navigationTitle("OrderMessage")
                        }
                        .onAppear {
                            settings.forEach { settingItem in
                                order.generateMessage(messageHeader: settingItem.messageHeader, messageFooter: settingItem.messageFooter)
                            }
                        }
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text("Order Date: \(order.timestamp, format: Date.FormatStyle(date: .numeric))")
                    Text("Units: \(String(order.units))")
                    ForEach(order.orderItems.sorted(by: {
                        return $0.mealIndex < $1.mealIndex
                    })) { orderItem in
                        HStack(spacing: 10) {
                            Text("\(orderItem.mealIndex).").font(.title3)
                            VStack(spacing: 5) {
                                Text(orderItem.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(orderItem.amount)
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            VStack(spacing: 5) {
                                Text("Qty: **\(orderItem.quantity)**, ")
                                Text("Units: **\(Double(orderItem.quantity) * orderItem.price, format: .number)**")
                            }
                        }
                        .swipeActions {
                            Button {
                                withAnimation {
                                    orderItem.quantity -= (orderItem.quantity >= 1 ? 1 : 0)
                                    order.units -= (orderItem.quantity >= 1 ? orderItem.price : 0)
                                    if orderItem.quantity <= 0 {
                                        order.orderItems.removeAll(where: {$0.id == orderItem.id})
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "minus")
                                    .symbolVariant(/*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            }
                            .tint(.red)
                            Button {
                                orderItem.quantity += 1
                                order.units += orderItem.price
                            } label: {
                                Label("Plus", systemImage: "plus")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .navigationTitle("Order Details")
                .toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Label("Settings", systemImage: "chevron.backward")
                        })
                    }
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button(action: {
                            showEditOrder.toggle()
                        }, label: {
                            Text("Edit")
                        })
                    }
                }
                .sheet(isPresented: $showEditOrder, content: {
                    NavigationStack {
                        CheckoutView(basket: Basket(categoryItems: categoryItems, order: order), order: order, isNewOrder: false)
                    }
                })
            }
        }
    }
    
    func copyToClipboard() {
        pasteboard.string = order.orderMessage
        self.copyButtonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copyButtonText = "Copy To Clipboard"
        }
    }
}

#Preview {
    struct Container: View {
        @Query var orders: [Order]
        var body: some View {
            OrderDetailsView(order: orders[0])
        }
    }
    return Container()
        .modelContainer(previewContainer)
}
