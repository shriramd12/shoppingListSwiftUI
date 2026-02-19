//
//  ShoppingListTests.swift
//  ShoppingListTests
//
//  Created by Shriram Dharmadhikari on 20/02/26.
//

import Testing
import Foundation
@testable import ShoppingList

// MARK: - Category Tests

struct CategoryTests {

    @Test func allCasesCount() {
        #expect(ShoppingCategory.allCases.count == 5)
    }

    @Test func rawValues() {
        #expect(ShoppingCategory.milk.rawValue == "Milk")
        #expect(ShoppingCategory.vegetables.rawValue == "Vegetables")
        #expect(ShoppingCategory.fruits.rawValue == "Fruits")
        #expect(ShoppingCategory.breads.rawValue == "Breads")
        #expect(ShoppingCategory.meats.rawValue == "Meats")
    }

    @Test func emojis() {
        #expect(ShoppingCategory.milk.emoji == "🥛")
        #expect(ShoppingCategory.vegetables.emoji == "🥦")
        #expect(ShoppingCategory.fruits.emoji == "🍎")
        #expect(ShoppingCategory.breads.emoji == "🍞")
        #expect(ShoppingCategory.meats.emoji == "🥩")
    }

    @Test func localizedNameIsNotEmpty() {
        for category in ShoppingCategory.allCases {
            #expect(!category.localizedName.isEmpty, "localizedName should not be empty for \(category)")
        }
    }

    @Test func codableRoundTrip() throws {
        for category in ShoppingCategory.allCases {
            let data = try JSONEncoder().encode(category)
            let decoded = try JSONDecoder().decode(ShoppingCategory.self, from: data)
            #expect(decoded == category)
        }
    }
}

// MARK: - Item Tests

struct ItemTests {

    @Test func defaultValues() {
        let item = ShoppingItem(name: "Bananas", category: .fruits)
        #expect(item.name == "Bananas")
        #expect(item.category == .fruits)
        #expect(item.isPurchased == false)
    }

    @Test func customIsPurchased() {
        let item = ShoppingItem(name: "Milk", category: .milk, isPurchased: true)
        #expect(item.isPurchased == true)
    }

    @Test func dateAddedDefaultsToNow() {
        let before = Date.now
        let item = ShoppingItem(name: "Bread", category: .breads)
        let after = Date.now
        #expect(item.dateAdded >= before)
        #expect(item.dateAdded <= after)
    }

    @Test func customDateAdded() {
        let date = Date(timeIntervalSince1970: 0)
        let item = ShoppingItem(name: "Steak", category: .meats, dateAdded: date)
        #expect(item.dateAdded == date)
    }

    @Test func togglePurchased() {
        let item = ShoppingItem(name: "Carrots", category: .vegetables)
        #expect(item.isPurchased == false)
        item.isPurchased.toggle()
        #expect(item.isPurchased == true)
        item.isPurchased.toggle()
        #expect(item.isPurchased == false)
    }

    @Test func mutateProperties() {
        let item = ShoppingItem(name: "Apple", category: .fruits)
        item.name = "Green Apple"
        item.category = .vegetables
        #expect(item.name == "Green Apple")
        #expect(item.category == .vegetables)
    }
}

// MARK: - Filtering & Sorting Logic Tests

struct FilteringTests {

    private func makeSampleItems() -> [ShoppingItem] {
        [
            ShoppingItem(name: "Whole Milk", category: .milk, isPurchased: false),
            ShoppingItem(name: "Cheddar Cheese", category: .milk, isPurchased: true),
            ShoppingItem(name: "Bananas", category: .fruits, isPurchased: false),
            ShoppingItem(name: "Broccoli", category: .vegetables, isPurchased: false),
            ShoppingItem(name: "Chicken Breast", category: .meats, isPurchased: true),
            ShoppingItem(name: "Sourdough Bread", category: .breads, isPurchased: false),
        ]
    }

    /// Mirrors the filteredItems logic from ShoppingListContainerView.
    private func filteredItems(from items: [ShoppingItem], category: ShoppingCategory?) -> [ShoppingItem] {
        let source = category == nil ? items : items.filter { $0.category == category }
        return source.sorted {
            if $0.isPurchased != $1.isPurchased { return !$0.isPurchased }
            return $0.name < $1.name
        }
    }

    /// Mirrors the groupedItems logic from ShoppingListContainerView.
    private func groupedItems(from filtered: [ShoppingItem]) -> [(category: ShoppingCategory, items: [ShoppingItem])] {
        ShoppingCategory.allCases.compactMap { category in
            let categoryItems = filtered.filter { $0.category == category }
            return categoryItems.isEmpty ? nil : (category, categoryItems)
        }
    }

    @Test func filterByAllReturnsEverything() {
        let items = makeSampleItems()
        let result = filteredItems(from: items, category: nil)
        #expect(result.count == items.count)
    }

    @Test func filterByCategoryReturnsOnlyThatCategory() {
        let items = makeSampleItems()
        let milkItems = filteredItems(from: items, category: .milk)
        #expect(milkItems.count == 2)
        for item in milkItems {
            #expect(item.category == .milk)
        }
    }

    @Test func filterByEmptyCategoryReturnsEmpty() {
        let items = [ShoppingItem(name: "Bananas", category: .fruits)]
        let result = filteredItems(from: items, category: .meats)
        #expect(result.isEmpty)
    }

    @Test func unpurchasedItemsSortedBeforePurchased() {
        let items = makeSampleItems()
        let result = filteredItems(from: items, category: nil)

        // Find the boundary where purchased items start
        let unpurchasedCount = result.filter { !$0.isPurchased }.count
        for i in 0..<unpurchasedCount {
            #expect(!result[i].isPurchased)
        }
        for i in unpurchasedCount..<result.count {
            #expect(result[i].isPurchased)
        }
    }

    @Test func itemsSortedAlphabeticallyWithinGroup() {
        let items = makeSampleItems()
        let result = filteredItems(from: items, category: nil)

        let unpurchased = result.filter { !$0.isPurchased }
        let purchased = result.filter { $0.isPurchased }

        for i in 1..<unpurchased.count {
            #expect(unpurchased[i - 1].name <= unpurchased[i].name)
        }
        for i in 1..<purchased.count {
            #expect(purchased[i - 1].name <= purchased[i].name)
        }
    }

    @Test func groupedItemsContainsOnlyNonEmptyCategories() {
        let items = makeSampleItems()
        let filtered = filteredItems(from: items, category: nil)
        let groups = groupedItems(from: filtered)

        for group in groups {
            #expect(!group.items.isEmpty)
        }

        // All sample categories are represented
        let groupCategories = Set(groups.map(\.category))
        #expect(groupCategories.count == 5)
    }

    @Test func groupedItemsOmitsMissingCategories() {
        let items = [ShoppingItem(name: "Bananas", category: .fruits)]
        let filtered = filteredItems(from: items, category: nil)
        let groups = groupedItems(from: filtered)

        #expect(groups.count == 1)
        #expect(groups[0].category == .fruits)
    }

    @Test func groupedItemsFollowsCategoryAllCasesOrder() {
        let items = makeSampleItems()
        let filtered = filteredItems(from: items, category: nil)
        let groups = groupedItems(from: filtered)

        let groupOrder = groups.map(\.category)
        let allCasesOrder = ShoppingCategory.allCases.filter { cat in
            groupOrder.contains(cat)
        }
        #expect(groupOrder == allCasesOrder)
    }

    @Test func filterFromEmptyListReturnsEmpty() {
        let result = filteredItems(from: [], category: nil)
        #expect(result.isEmpty)
    }

    @Test func groupFromEmptyListReturnsEmpty() {
        let groups = groupedItems(from: [])
        #expect(groups.isEmpty)
    }
}
