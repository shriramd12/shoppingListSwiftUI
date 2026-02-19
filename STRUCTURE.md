# Project Structure

```
ShoppingList/
├── ShoppingListApp.swift
├── Constants.swift
├── Localizable.xcstrings
├── Assets.xcassets/
├── Model/
│   └── ShoppingItem.swift
├── Views/
│   ├── ShoppingList/
│   │   ├── ShoppingListContainerView.swift
│   │   ├── ShoppingListView.swift
│   │   ├── ShoppingListItemView.swift
│   │   └── EmptyStateView.swift
│   └── ItemForm/
│       ├── AddItemView.swift
│       └── EditItemView.swift
└── Components/
    ├── FilterView.swift
    └── FilterChip.swift

ShoppingListTests/
└── ShoppingListTests.swift

ShoppingListUITests/
├── ShoppingListUITests.swift
└── ShoppingListUITestsLaunchTests.swift
```

## File Descriptions

### App

| File | Purpose |
|------|---------|
| `ShoppingListApp.swift` | App entry point. Configures the SwiftData `ModelContainer` and sets `ShoppingListContainerView` as the root view. |
| `Constants.swift` | Central store for spacing, corner radius, size, animation, icon names, color, and accessibility identifier constants. |
| `Localizable.xcstrings` | Xcode String Catalog containing all localized UI strings with snake_case keys. |

### Model

| File | Purpose |
|------|---------|
| `ShoppingItem.swift` | Defines `ShoppingCategory` enum (milk, vegetables, fruits, breads, meats) with emoji and localized names, and the `ShoppingItem` SwiftData model with name, category, purchased status, and date added. |

### Views / ShoppingList

| File | Purpose |
|------|---------|
| `ShoppingListContainerView.swift` | Main screen. Hosts the add-item section, filter bar, and item list inside a single `List`. Manages filtering, grouping, and CRUD actions. |
| `ShoppingListView.swift` | Renders items either grouped by category sections (All filter) or as a flat list (single category filter). Includes swipe actions and context menus. |
| `ShoppingListItemView.swift` | Single item row displaying a toggle button, category emoji badge, item name, and category label. |
| `EmptyStateView.swift` | Shows a `ContentUnavailableView` when there are no items or no items match the selected filter. Includes a "Clear Filter" button when a category filter is active. |

### Views / ItemForm

| File | Purpose |
|------|---------|
| `AddItemView.swift` | Inline form section for adding new items with category selection, item name text field, and an add button. |
| `EditItemView.swift` | Modal sheet form for editing an existing item's name and category, with a live preview. |

### Components

| File | Purpose |
|------|---------|
| `FilterView.swift` | Horizontally scrollable row of filter chips. Accepts a `parentID` for unique accessibility identifiers. Reused in both the add-item section and the list filter bar. |
| `FilterChip.swift` | Capsule-styled button displaying an emoji and label with selected/unselected styling. |

### Tests

| File | Purpose |
|------|---------|
| `ShoppingListTests.swift` | Unit tests (Swift Testing) covering category properties, item model behaviour, and filtering/sorting/grouping logic. |
| `ShoppingListUITests.swift` | UI tests (XCUITest) covering add, filter, toggle, edit, delete, empty state, and grouped section flows using accessibility identifiers. |
| `ShoppingListUITestsLaunchTests.swift` | Launch test that captures a screenshot after app launch. |
