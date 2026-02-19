# Shopping List

A SwiftUI shopping list app built with SwiftData for persistent storage. Organize items by category, filter by type, and track purchased items.

## Requirements

- Xcode 26.2
- iOS 17.0+ deployment target

## Build & Run

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ShoppingList
   ```

2. Open the project in Xcode:
   ```bash
   open ShoppingList.xcodeproj
   ```

3. Select a simulator or connected device running iOS 17 or later.

4. Press `Cmd + R` to build and run.

## Requirements Fulfilled

### Adding Items
- User can enter an item name via a text input field
- User can select a category from predefined options: Milk, Vegetables, Fruits, Breads, Meats
- User can add the item to the list by tapping the "Add Item" button
- The input field clears after successfully adding an item

### Displaying Items
- All added items are displayed in a list view
- Each item shows its name and associated category
- An empty state message is shown when no items have been added

### Managing Items
- User can mark items as purchased/completed
- User can delete items from the list
- User can edit existing items (name and/or category)

### Filtering & Organization
- User can filter the list by category
- Items are visually grouped by their category

### Data Persistence
- The shopping list persists between app launches using SwiftData
- All item data (name, category, completion status) is saved

## Additional Support

- Localization support via Xcode String Catalog with snake_case keys
- Dark mode support
- Landscape and portrait orientation support
- Unit tests (Swift Testing) and UI tests (XCUITest)

## Demo

[App Demo](https://drive.google.com/file/d/1jt6dtG3OufScRzncnr_uO9IRAgEA8Bdc/view?usp=sharing)

## Tests

- **Unit Tests:** Open `ShoppingListTests/ShoppingListTests.swift` and run the tests.
- **UI Tests:** Open `ShoppingListUITests/ShoppingListUITests.swift` and run the tests.
