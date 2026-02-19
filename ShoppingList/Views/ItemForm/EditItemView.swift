//
//  EditItemView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss

    // We edit the SwiftData model object directly; changes are
    // automatically tracked and saved by the model context.
    let item: ShoppingItem

    @State private var name: String
    @State private var selectedCategory: ShoppingCategory

    init(item: ShoppingItem) {
        self.item = item
        // Seed state from the existing item's current values
        _name = State(initialValue: item.name)
        _selectedCategory = State(initialValue: item.category)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("item_details") {
                    TextField("item_name", text: $name)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier(Constants.AccessibilityID.editItemNameField)

                    Picker("category", selection: $selectedCategory) {
                        ForEach(ShoppingCategory.allCases, id: \.self) { category in
                            Label(category.localizedName, systemImage: "")
                                .tag(category)
                        }
                    }
                }

                Section("preview") {
                    ShoppingListItemView(item: previewItem, onToggle: {})
                }
            }
            .navigationTitle("edit_item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") { dismiss() }
                        .accessibilityIdentifier(Constants.AccessibilityID.editItemCancelButton)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("save") {
                        saveChanges()
                    }
                    .disabled(!canSave)
                    .fontWeight(.semibold)
                    .accessibilityIdentifier(Constants.AccessibilityID.editItemSaveButton)
                }
            }
        }
    }

    private var previewItem: ShoppingItem {
        ShoppingItem(
            name: name.trimmingCharacters(in: .whitespaces).isEmpty ? item.name : name,
            category: selectedCategory,
            isPurchased: item.isPurchased
        )
    }

    private func saveChanges() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        item.name = trimmed
        item.category = selectedCategory
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ShoppingItem.self, configurations: config)
    let sample = ShoppingItem(name: "Whole Milk", category: .milk)
    container.mainContext.insert(sample)

    return EditItemView(item: sample)
        .modelContainer(container)
}
