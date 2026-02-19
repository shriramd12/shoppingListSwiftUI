//
//  Item.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import Foundation
import SwiftData

// MARK: - Category

enum Category: String, CaseIterable, Codable {
    case milk       = "Milk"
    case vegetables = "Vegetables"
    case fruits     = "Fruits"
    case breads     = "Breads"
    case meats      = "Meats"

    /// The localization key for this category in the string catalog.
    var localizationKey: String.LocalizationValue {
        switch self {
        case .milk:       return "category_milk"
        case .vegetables: return "category_vegetables"
        case .fruits:     return "category_fruits"
        case .breads:     return "category_breads"
        case .meats:      return "category_meats"
        }
    }

    /// The category name resolved through the Localizable string catalog.
    var localizedName: String {
        String(localized: localizationKey)
    }

    var emoji: String {
        switch self {
        case .milk:       return "🥛"
        case .vegetables: return "🥦"
        case .fruits:     return "🍎"
        case .breads:     return "🍞"
        case .meats:      return "🥩"
        }
    }
}

// MARK: - Item Model

@Model
final class Item {
    var name: String
    var category: Category
    var isPurchased: Bool
    var dateAdded: Date

    init(name: String, category: Category, isPurchased: Bool = false, dateAdded: Date = .now) {
        self.name = name
        self.category = category
        self.isPurchased = isPurchased
        self.dateAdded = dateAdded
    }
}
