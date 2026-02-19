//
//  ShoppingListSection.swift
//  ShoppingList
//

import SwiftUI

struct ShoppingListView: View {
    let selectedCategory: ShoppingCategory?
    let filteredItems: [ShoppingItem]
    let groupedItems: [(category: ShoppingCategory, items: [ShoppingItem])]
    let onToggle: (ShoppingItem) -> Void
    let onEdit: (ShoppingItem) -> Void
    let onDelete: (ShoppingItem) -> Void
    let onDeleteAtOffsets: (IndexSet) -> Void

    var body: some View {
        if selectedCategory == nil {
            ForEach(groupedItems, id: \.category) { group in
                Section {
                    ForEach(group.items) { item in
                        itemRow(for: item)
                    }
                } header: {
                    HStack(spacing: Constants.Spacing.small) {
                        Text(group.category.emoji)
                        Text(group.category.localizedName)
                    }
                }
            }
        } else {
            ForEach(filteredItems) { item in
                itemRow(for: item)
            }
            .onDelete(perform: onDeleteAtOffsets)
        }
    }

    private func itemRow(for item: ShoppingItem) -> some View {
        ShoppingListItemView(item: item) {
            onToggle(item)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete(item)
            } label: {
                Label("delete", systemImage: Constants.Icons.trash)
            }
            .accessibilityIdentifier(Constants.AccessibilityID.deleteAction)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                onEdit(item)
            } label: {
                Label("edit", systemImage: Constants.Icons.pencil)
            }
            .tint(Constants.Colors.editAction)
            .accessibilityIdentifier(Constants.AccessibilityID.editAction)
        }
        .contextMenu {
            Button {
                onEdit(item)
            } label: {
                Label("edit", systemImage: Constants.Icons.pencil)
            }
            .accessibilityIdentifier(Constants.AccessibilityID.editAction)
            Button(role: .destructive) {
                onDelete(item)
            } label: {
                Label("delete", systemImage: Constants.Icons.trash)
            }
            .accessibilityIdentifier(Constants.AccessibilityID.deleteAction)
        }
    }
}
