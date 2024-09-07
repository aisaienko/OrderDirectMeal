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
    
    init(messageHeader: String = "", messageFooter: String = "") {
        self.id = UUID().uuidString
        self.messageHeader = messageHeader
        self.messageFooter = messageFooter
    }
}
