//
//  ContentView.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreateOrder = false
    @State private var showSettingsView = false
    @State private var orderDetails: Order?
    @Query(
        sort: \Order.timestamp,
        order: .reverse
    ) private var orders: [Order]

    var body: some View {
        NavigationStack {
            List {
                ForEach(orders) { order in
                    HStack {
                        Text("\(order.timestamp, format: Date.FormatStyle(date: .numeric)), Units: \(String(order.units))")
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(order)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(/*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button {
                            orderDetails = order
                        } label: {
                            Label("See Details", systemImage: "magnifyingglass")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("My Orders")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button(action: {
                        showSettingsView.toggle()
                    }, label: {
                        Label("Settings", systemImage: "gearshape")
                    })
                }
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateOrder.toggle()
                    }, label: {
                        Label("Add Order", systemImage: "plus")
                    })
                }
            }
            .sheet(isPresented: $showCreateOrder, content: {
                NavigationStack {
                    CheckoutView(basket: Basket())
                }
            })
            .sheet(isPresented: $showSettingsView, content: {
                NavigationStack {
                    SettingsView()
                }
            })
            .sheet(item: $orderDetails) {
                orderDetails = nil
            } content: { order in
                OrderDetailsView(order: order)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Order.self])
}
