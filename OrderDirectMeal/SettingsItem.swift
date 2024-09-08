//
//  SettingsItem.swift
//  OrderDirectMeal
//
//  Created by Oleksandr Isaienko on 9/5/24.
//

import Foundation
import SwiftData

@Model
final class SettingsItem: Identifiable {
    var id: String
    var messageHeader: String
    var messageFooter: String
    var menuURL: String
    
    init(messageHeader: String = "", messageFooter: String = "", menuURL: String = "") {
        self.id = UUID().uuidString
        self.messageHeader = messageHeader
        self.messageFooter = messageFooter
        self.menuURL = menuURL
    }
}
