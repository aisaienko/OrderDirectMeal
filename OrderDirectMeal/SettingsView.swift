//
//  SettingsView.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var isLoading: Bool = false
    @State private var buttonText = "Update Menu"
    
    @Query private var settingsItems: [SettingsItem]
    @Query private var categoryItems: [CategoryItem]
    
    var body: some View {
        VStack {
            NavigationStack {
                ForEach (settingsItems) { settingsItem in
                    VStack {
                        Form {
                            Section(header: Text("Message Header")) {
                                TextEditor(text: Bindable(settingsItem).messageHeader)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                            }
                            Section(header: Text("Message Footer")) {
                                TextEditor(text: Bindable(settingsItem).messageFooter)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                            }
                            Section(header: Text("Menu URL")) {
                                TextField("Menu URL", text: Bindable(settingsItem).menuURL)
                                    .padding(.horizontal)
                                    .textFieldStyle(.roundedBorder)
                                Button(action: {
                                    withAnimation {
                                        self.isLoading = true
                                        if settingsItem.menuURL.isEmpty == false {
                                            MealItemsJSONDecoder.decodeFromUrl(urlPath: settingsItem.menuURL) { (categories) in
                                                if (categories ?? []).isEmpty == false {
                                                    updateCategories(categories: categories)
                                                    self.buttonText = "Updated!"
                                                } else {
                                                    self.buttonText = "Update was failed!"
                                                }
                                                self.isLoading = false

                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                    self.buttonText = "Update Menu"
                                                }
                                            }
                                        }
                                    }
                                }, label: {
                                    if isLoading {
                                        HStack {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                                .padding(.trailing, 15)
                                            Text("Loading...")
                                        }
                                    } else {
                                        Label(buttonText, systemImage: "arrow.clockwise")
                                    }
                                })
                            }
                        }
                    }
                }
                Button("Save and Back to Orders", systemImage: "chevron.backward") {
                    dismiss()
                }
            }
        }
    }
    
    func updateCategories(categories: [MealCategoriesResponse]?) {
        do {
            // remove existing categories
            try modelContext.delete(model: CategoryItem.self)
            
            // create new categories from URL
            (categories ?? []).forEach { categoryItem in
                let category = CategoryItem(name: categoryItem.name, index: categoryItem.index)
                modelContext.insert(category)
                categoryItem.mealItems.sorted {
                    $0.mealIndex < $1.mealIndex
                }.forEach {mealItem in
                    let item = ProductItem(name: mealItem.name, price: mealItem.price, mealIndex: mealItem.mealIndex, amount: mealItem.amount)
                    category.productItems.append(item)
                }
                try? modelContext.save()
            }
        } catch {
            self.buttonText = "Update was failed!"
        }
    }
}

#Preview {
    struct Container: View {
        var body: some View {
            SettingsView()
        }
    }
    return Container()
        .modelContainer(previewContainer)
}
