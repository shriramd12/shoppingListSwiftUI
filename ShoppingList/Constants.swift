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

    // MARK: - Shadow

    enum Shadow {
        static let opacity: Double = 0.08
        static let radius: CGFloat = 8
        static let x: CGFloat = 0
        static let y: CGFloat = 2
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

    // MARK: - Colors

    enum Colors {
        static let chipSelected = Color.accentColor
        static let chipDefault = Color(.systemGray5)
        static let textFieldBackground = Color(.systemGray6)
        static let cardBackground = Color(.systemBackground)
        static let purchased = Color.green
        static let editAction = Color.orange
        static let cardShadow = Color.black.opacity(Shadow.opacity)
    }
}
