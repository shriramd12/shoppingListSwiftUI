//
//  ItemRowView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI

struct ShoppingListItemView: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: Constants.Spacing.large) {
            // Completion toggle button
            Button(action: onToggle) {
                Image(systemName: item.isPurchased ? Constants.Icons.checkmarkCircleFill : Constants.Icons.circle)
                    .font(.title2)
                    .foregroundStyle(item.isPurchased ? Constants.Colors.purchased : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(Constants.AccessibilityID.itemToggle(item.name))

            // Category emoji badge + item details
            HStack(spacing: Constants.Spacing.medium) {
                Text(item.category.emoji)
                    .font(.title3)
                    .frame(width: Constants.Size.emojiBadge, height: Constants.Size.emojiBadge)
                    .background(.quaternary, in: Circle())

                VStack(alignment: .leading, spacing: Constants.Spacing.xxSmall) {
                    Text(item.name)
                        .font(.body)
                        .strikethrough(item.isPurchased, color: .secondary)
                        .foregroundStyle(item.isPurchased ? .secondary : .primary)
                        .accessibilityIdentifier(Constants.AccessibilityID.itemRow(item.name))

                    Text(item.category.localizedName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, Constants.Spacing.xSmall)
        .animation(.easeInOut(duration: Constants.Animation.standard), value: item.isPurchased)
    }
}
