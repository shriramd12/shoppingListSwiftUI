//
//  Constants.swift
//  ShoppingList
//

import SwiftUI

enum Constants {

    // MARK: - Spacing

    enum Spacing {
        static let xxSmall: CGFloat = 2
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 6
        static let medium: CGFloat = 8
        static let regular: CGFloat = 10
        static let large: CGFloat = 12
        static let xLarge: CGFloat = 16
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 16
    }

    // MARK: - Size

    enum Size {
        static let emojiBadge: CGFloat = 32
        static let categoryPickerButton: CGFloat = 40
    }

    // MARK: - Animation

    enum Animation {
        static let fast: Double = 0.15
        static let standard: Double = 0.2
    }

    // MARK: - Icons

    enum Icons {
        static let cart = "cart"
        static let cartFill = "cart.fill"
        static let checkmarkCircleFill = "checkmark.circle.fill"
        static let circle = "circle"
        static let emptyCategory = "line.3.horizontal.decrease.circle"
        static let pencil = "pencil"
        static let plusCircleFill = "plus.circle.fill"
        static let trash = "trash"
    }

    // MARK: - Accessibility Identifiers

    enum AccessibilityID {
        // Add Item Section
        static let addItemTitle = "add_item_title"
        static let addItemTextField = "add_item_text_field"
        static let addItemButton = "add_item_button"

        // Filter
        static func filterAll(_ parent: String) -> String { "\(parent)_filter_chip_all" }
        static func filterChip(_ parent: String, _ category: String) -> String { "\(parent)_filter_chip_\(category)" }

        // Shopping List Items
        static func itemRow(_ name: String) -> String { "item_row_\(name)" }
        static func itemToggle(_ name: String) -> String { "item_toggle_\(name)" }

        // Empty State
        static let emptyStateTitle = "empty_state_title"
        static let emptyStateBody = "empty_state_body_text"
        static let clearFilterButton = "clear_filter_button"

        // Edit Item
        static let editItemNameField = "edit_item_name_field"
        static let editItemCancelButton = "edit_item_cancel"
        static let editItemSaveButton = "edit_item_save"

        // Swipe & Context Menu
        static let editAction = "edit_action"
        static let deleteAction = "delete_action"
    }

    // MARK: - Colors

    enum Colors {
        static let chipSelected = Color.accentColor
        static let chipDefault = Color(.systemGray5)
        static let textFieldBackground = Color(.tertiarySystemGroupedBackground)
        static let cardBackground = Color(.systemBackground)
        static let purchased = Color.green
        static let editAction = Color.orange
    }
}
