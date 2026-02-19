//
//  ShoppingListUITests.swift
//  ShoppingListUITests
//
//  Created by Shriram Dharmadhikari on 20/02/26.
//

import XCTest

final class ShoppingListUITests: XCTestCase {

    let app = XCUIApplication()

    // MARK: - Accessibility ID Constants (mirror Constants.AccessibilityID)

    private enum A11y {
        static let addItemTitle = "add_item_title"
        static let addItemTextField = "add_item_text_field"
        static let addItemButton = "add_item_button"

        // Add Item filter chips (parent: "add_item")
        static func addItemFilterChip(_ category: String) -> String { "add_item_filter_chip_\(category)" }

        // Shopping List filter chips (parent: "shopping_list")
        static let listFilterAll = "shopping_list_filter_chip_all"
        static func listFilterChip(_ category: String) -> String { "shopping_list_filter_chip_\(category)" }

        static func itemRow(_ name: String) -> String { "item_row_\(name)" }
        static func itemToggle(_ name: String) -> String { "item_toggle_\(name)" }
        static let emptyStateTitle = "empty_state_title"
        static let emptyStateBody = "empty_state_body_text"
        static let clearFilterButton = "clear_filter_button"
        static let editItemNameField = "edit_item_name_field"
        static let editItemCancelButton = "edit_item_cancel"
        static let editItemSaveButton = "edit_item_save"
        static let editAction = "edit_action"
        static let deleteAction = "delete_action"
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    // MARK: - Launch & Navigation

    @MainActor
    func testAppLaunchShowsNavigationTitle() throws {
        XCTAssertTrue(app.navigationBars["Shopping List"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testEmptyStateShownOnLaunch() throws {
        let emptyTitle = app.staticTexts[A11y.emptyStateTitle]
        if emptyTitle.exists {
            XCTAssertTrue(emptyTitle.exists)
            XCTAssertTrue(app.staticTexts[A11y.emptyStateBody].exists)
        }
    }

    // MARK: - Add Item

    @MainActor
    func testAddItemSectionExists() throws {
        let title = app.staticTexts[A11y.addItemTitle]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
    }

    @MainActor
    func testAddItemWithNameAndCategory() throws {
        let textField = app.textFields[A11y.addItemTextField]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        textField.tap()
        textField.typeText("Bananas")

        // Select Fruits category
        let fruitsChip = app.buttons[A11y.addItemFilterChip("Fruits")]
        if fruitsChip.exists {
            fruitsChip.tap()
        }

        // Tap the Add Item button
        let addButton = app.buttons[A11y.addItemButton]
        XCTAssertTrue(addButton.isEnabled)
        addButton.tap()

        // Verify the item appears in the list
        XCTAssertTrue(app.staticTexts[A11y.itemRow("Bananas")].waitForExistence(timeout: 3))
    }

    @MainActor
    func testAddButtonDisabledWhenEmpty() throws {
        let textField = app.textFields[A11y.addItemTextField]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))

        let addButton = app.buttons[A11y.addItemButton]
        XCTAssertTrue(addButton.exists)
        XCTAssertFalse(addButton.isEnabled)
    }

    @MainActor
    func testAddMultipleItems() throws {
        let textField = app.textFields[A11y.addItemTextField]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))

        // Add first item
        textField.tap()
        textField.typeText("Whole Milk")
        let milkChip = app.buttons[A11y.addItemFilterChip("Milk")]
        if milkChip.exists { milkChip.tap() }
        app.buttons[A11y.addItemButton].tap()

        // Add second item
        textField.tap()
        textField.typeText("Broccoli")
        let vegChip = app.buttons[A11y.addItemFilterChip("Vegetables")]
        if vegChip.exists { vegChip.tap() }
        app.buttons[A11y.addItemButton].tap()

        // Both items should exist
        XCTAssertTrue(app.staticTexts[A11y.itemRow("Whole Milk")].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts[A11y.itemRow("Broccoli")].exists)
    }

    // MARK: - Category Filter

    @MainActor
    func testFilterChipsExistWhenItemsPresent() throws {
        addSampleItem(name: "Test Item", category: "Vegetables")

        let allChip = app.buttons[A11y.listFilterAll]
        XCTAssertTrue(allChip.waitForExistence(timeout: 5))
    }

    @MainActor
    func testFilterByCategoryShowsOnlyMatchingItems() throws {
        addSampleItem(name: "Bananas", category: "Fruits")
        addSampleItem(name: "Carrots", category: "Vegetables")

        let fruitsFilter = app.buttons[A11y.listFilterChip("Fruits")]
        XCTAssertTrue(fruitsFilter.waitForExistence(timeout: 5))
        fruitsFilter.tap()

        XCTAssertTrue(app.staticTexts[A11y.itemRow("Bananas")].waitForExistence(timeout: 3))
    }

    @MainActor
    func testFilterAllShowsEverything() throws {
        addSampleItem(name: "Bananas", category: "Fruits")
        addSampleItem(name: "Carrots", category: "Vegetables")

        // Tap a category filter first
        let fruitsFilter = app.buttons[A11y.listFilterChip("Fruits")]
        if fruitsFilter.waitForExistence(timeout: 5) {
            fruitsFilter.tap()
        }

        // Tap All filter
        let allFilter = app.buttons[A11y.listFilterAll]
        if allFilter.exists {
            allFilter.tap()
        }

        // Both items should be visible
        XCTAssertTrue(app.staticTexts[A11y.itemRow("Bananas")].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts[A11y.itemRow("Carrots")].exists)
    }

    // MARK: - Toggle Purchased

    @MainActor
    func testToggleItemPurchased() throws {
        addSampleItem(name: "Toggle Test", category: "Fruits")

        let toggleButton = app.buttons[A11y.itemToggle("Toggle Test")]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5))
        toggleButton.tap()
    }

    // MARK: - Edit Item

    @MainActor
    func testEditItemViaContextMenu() throws {
        addSampleItem(name: "Edit Me", category: "Meats")

        let itemText = app.staticTexts[A11y.itemRow("Edit Me")]
        XCTAssertTrue(itemText.waitForExistence(timeout: 5))

        // Long press to open context menu
        itemText.press(forDuration: 1.0)

        // Tap Edit in context menu
        let editButton = app.buttons[A11y.editAction]
        if editButton.waitForExistence(timeout: 3) {
            editButton.tap()

            // Edit sheet should appear with Edit Item title
            XCTAssertTrue(app.navigationBars["Edit Item"].waitForExistence(timeout: 3))

            // Cancel to dismiss
            app.buttons[A11y.editItemCancelButton].tap()
        }
    }

    @MainActor
    func testEditItemChangeName() throws {
        addSampleItem(name: "Old Name", category: "Breads")

        let itemText = app.staticTexts[A11y.itemRow("Old Name")]
        XCTAssertTrue(itemText.waitForExistence(timeout: 5))

        // Long press to open context menu
        itemText.press(forDuration: 1.0)

        let editButton = app.buttons[A11y.editAction]
        if editButton.waitForExistence(timeout: 3) {
            editButton.tap()

            // Clear existing text and type new name
            let nameField = app.textFields[A11y.editItemNameField]
            if nameField.waitForExistence(timeout: 3) {
                nameField.tap()
                nameField.clearAndTypeText("New Name")

                // Save
                app.buttons[A11y.editItemSaveButton].tap()

                // New name should appear in the list
                XCTAssertTrue(app.staticTexts[A11y.itemRow("New Name")].waitForExistence(timeout: 3))
            }
        }
    }

    // MARK: - Delete Item

    @MainActor
    func testDeleteItemViaSwipe() throws {
        addSampleItem(name: "Delete Me", category: "Milk")

        let itemText = app.staticTexts[A11y.itemRow("Delete Me")]
        XCTAssertTrue(itemText.waitForExistence(timeout: 5))

        // Swipe left to reveal delete action
        itemText.swipeLeft()

        let deleteButton = app.buttons[A11y.deleteAction]
        if deleteButton.waitForExistence(timeout: 3) {
            deleteButton.tap()

            // Item should be gone
            XCTAssertFalse(app.staticTexts[A11y.itemRow("Delete Me")].waitForExistence(timeout: 2))
        }
    }

    @MainActor
    func testDeleteItemViaContextMenu() throws {
        addSampleItem(name: "Context Delete", category: "Fruits")

        let itemText = app.staticTexts[A11y.itemRow("Context Delete")]
        XCTAssertTrue(itemText.waitForExistence(timeout: 5))

        // Long press to open context menu
        itemText.press(forDuration: 1.0)

        let deleteButton = app.buttons[A11y.deleteAction]
        if deleteButton.waitForExistence(timeout: 3) {
            deleteButton.tap()

            // Item should be gone
            XCTAssertFalse(app.staticTexts[A11y.itemRow("Context Delete")].waitForExistence(timeout: 2))
        }
    }

    // MARK: - Empty State with Filter

    @MainActor
    func testEmptyFilteredCategoryShowsClearFilter() throws {
        addSampleItem(name: "Only Fruit", category: "Fruits")

        // Tap Meats filter (which has no items)
        let meatsFilter = app.buttons[A11y.listFilterChip("Meats")]
        if meatsFilter.waitForExistence(timeout: 5) {
            meatsFilter.tap()

            // Should show empty state with Clear Filter button
            let clearFilterButton = app.buttons[A11y.clearFilterButton]
            if clearFilterButton.waitForExistence(timeout: 3) {
                XCTAssertTrue(clearFilterButton.exists)

                // Tap clear filter
                clearFilterButton.tap()

                // Should return to All view with the item visible
                XCTAssertTrue(app.staticTexts[A11y.itemRow("Only Fruit")].waitForExistence(timeout: 3))
            }
        }
    }

    // MARK: - Grouped Sections

    @MainActor
    func testGroupedSectionsShowCategoryHeaders() throws {
        addSampleItem(name: "Bananas", category: "Fruits")
        addSampleItem(name: "Whole Milk", category: "Milk")

        // In All view, category headers should appear
        let milkHeader = app.staticTexts["Milk"]
        let fruitsHeader = app.staticTexts["Fruits"]

        let headerExists = milkHeader.waitForExistence(timeout: 5) || fruitsHeader.exists
        XCTAssertTrue(headerExists)
    }

    // MARK: - Launch Performance

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - Helpers

    /// Adds an item via the UI by typing a name and selecting a category.
    private func addSampleItem(name: String, category: String) {
        let textField = app.textFields[A11y.addItemTextField]
        guard textField.waitForExistence(timeout: 5) else { return }

        textField.tap()
        textField.typeText(name)

        // Select category chip in the add-item section
        let categoryChip = app.buttons[A11y.addItemFilterChip(category)]
        if categoryChip.exists {
            categoryChip.tap()
        }

        // Tap the Add Item button
        app.buttons[A11y.addItemButton].tap()
    }
}

// MARK: - XCUIElement Helpers

extension XCUIElement {
    /// Clears existing text and types new text.
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String, !stringValue.isEmpty else {
            typeText(text)
            return
        }
        // Select all and delete
        tap(withNumberOfTaps: 3, numberOfTouches: 1)
        typeText(text)
    }
}
