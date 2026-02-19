//
//  AddItemView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI
import SwiftData

struct InlineAddItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var selectedCategory: ShoppingCategory? = .vegetables
    @FocusState private var nameFieldFocused: Bool

    private var canAdd: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        Section {

            // Add Item Title
            VStack {
                Text("add_item")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier(Constants.AccessibilityID.addItemTitle)
            }
            .frame(maxWidth: .infinity)
    
            // Category label + filter chips
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                Text("category")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                FilterView(selectedCategory: $selectedCategory, showAll: false, parentID: "add_item")
            }

            Text("item_name")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            // Item name text field
            TextField("add_item_placeholder", text: $name)
                .focused($nameFieldFocused)
                .submitLabel(.done)
                .onSubmit { addItem() }
                .padding(.horizontal, Constants.Spacing.large)
                .padding(.vertical, Constants.Spacing.regular)
                .background(
                    Constants.Colors.textFieldBackground,
                    in: RoundedRectangle(
                        cornerRadius: Constants.CornerRadius.small
                    ))
                .accessibilityIdentifier(Constants.AccessibilityID.addItemTextField)

            // Full-width add button
            Button(action: addItem) {
                Text("add_item")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!canAdd)
            .accessibilityIdentifier(Constants.AccessibilityID.addItemButton)
            .animation(.easeInOut(duration: Constants.Animation.fast), value: canAdd)
            .listRowInsets(
                EdgeInsets(
                    top: Constants.Spacing.medium,
                    leading: Constants.Spacing.xLarge,
                    bottom: Constants.Spacing.medium,
                    trailing: Constants.Spacing.xLarge
                ))
        }.listRowSeparator(.hidden)
    }

    private func addItem() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let category = selectedCategory else { return }
        withAnimation {
            modelContext.insert(ShoppingItem(name: trimmed, category: category))
        }
        name = ""
        nameFieldFocused = false
    }
}

// Keep the old name as a convenience alias so nothing else breaks
typealias AddItemView = InlineAddItemView

#Preview {
    List {
        InlineAddItemView()
    }
    .listStyle(.insetGrouped)
    .modelContainer(for: ShoppingItem.self, inMemory: true)
}
