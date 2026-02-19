//
//  EmptyStateView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI

struct EmptyStateView: View {
    let selectedCategory: Category?
    let onClearFilter: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(
                selectedCategory == nil
                    ? String(localized: "no_items_yet")
                    : String(localized: "no_category_items \(selectedCategory!.localizedName)"),
                systemImage: selectedCategory == nil ? Constants.Icons.cart : Constants.Icons.emptyCategory
            )
        } description: {
            Text(
                selectedCategory == nil
                    ? String(localized: "empty_state_body")
                    : String(localized: "empty_category_body")
            )
        } actions: {
            if selectedCategory != nil {
                Button("clear_filter") {
                    onClearFilter()
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
