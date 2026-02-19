//
//  ContentView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI
import SwiftData

struct ShoppingListContainerView: View {
    @Environment(\.modelContext) private var modelContext

    // Fetch all items, sorted alphabetically. Purchased/unpurchased
    // ordering is applied in `filteredItems` since Bool isn't
    // supported by SwiftData's SortDescriptor.
    @Query(sort: \ShoppingItem.name) private var items: [ShoppingItem]

    @State private var itemToEdit: ShoppingItem? = nil
    @State private var selectedCategory: ShoppingCategory? = nil  // nil = "All"

    // Items filtered by the selected category chip, then sorted so
    // unpurchased items appear first, with alphabetical ordering within
    // each group.
    private var filteredItems: [ShoppingItem] {
        let source = selectedCategory == nil ? items : items.filter { $0.category == selectedCategory }
        return source.sorted {
            if $0.isPurchased != $1.isPurchased { return !$0.isPurchased }
            return $0.name < $1.name
        }
    }

    /// Items grouped by category, only used when "All" filter is active.
    private var groupedItems: [(category: ShoppingCategory, items: [ShoppingItem])] {
        ShoppingCategory.allCases.compactMap { category in
            let categoryItems = filteredItems.filter { $0.category == category }
            return categoryItems.isEmpty ? nil : (category, categoryItems)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Add-item section
                InlineAddItemView()

                // Different Section for empty and non-empty
                if items.isEmpty {
                    EmptyStateView(selectedCategory: nil, onClearFilter: {})
                } else {
                    // Category filter chips section
                    Section {
                        FilterView(selectedCategory: $selectedCategory, parentID: "shopping_list")
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                    }
    
                    // Main list or empty state
                    if filteredItems.isEmpty {
                        Section {
                            EmptyStateView(selectedCategory: selectedCategory) {
                                withAnimation { selectedCategory = nil }
                            }
                            .listRowBackground(Color.clear)
                        }
                    } else {
                        ShoppingListView(
                            selectedCategory: selectedCategory,
                            filteredItems: filteredItems,
                            groupedItems: groupedItems,
                            onToggle: togglePurchased,
                            onEdit: { itemToEdit = $0 },
                            onDelete: deleteItem,
                            onDeleteAtOffsets: deleteItems
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .animation(.default, value: filteredItems.map(\.isPurchased))
            .sheet(item: $itemToEdit) { item in
                EditItemView(item: item)
            }
            .navigationTitle("shopping_list")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Actions

    private func togglePurchased(_ item: ShoppingItem) {
        withAnimation {
            item.isPurchased.toggle()
        }
    }

    private func deleteItem(_ item: ShoppingItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ShoppingItem.self, configurations: config)

    let samples: [(String, ShoppingCategory)] = [
        ("Whole Milk", .milk),
        ("Sourdough Bread", .breads),
        ("Chicken Breast", .meats),
        ("Bananas", .fruits),
        ("Broccoli", .vegetables),
        ("Cheddar Cheese", .milk)
    ]
    for (name, cat) in samples {
        container.mainContext.insert(ShoppingItem(name: name, category: cat))
    }

    return ShoppingListContainerView()
        .modelContainer(container)
}
