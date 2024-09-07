//
//  OrderDirectMealApp.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import SwiftUI
import SwiftData

@main
struct OrderDirectMealApp: App {

    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
}
