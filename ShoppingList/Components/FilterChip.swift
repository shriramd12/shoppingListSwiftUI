//
//  FilterChip.swift
//  ShoppingList
//

import SwiftUI

struct FilterChip: View {
    let label: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Constants.Spacing.xSmall) {
                Text(emoji)
                Text(label)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .font(.subheadline)
            .padding(.horizontal, Constants.Spacing.large)
            .padding(.vertical, Constants.Spacing.small)
            .background(isSelected ? Constants.Colors.chipSelected : Constants.Colors.chipDefault, in: Capsule())
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
