//
//  FilterView.swift
//  ShoppingList
//
//  Created by Shriram Dharmadhikari on 19/02/26.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedCategory: ShoppingCategory?
    var showAll: Bool = true
    var parentID: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Spacing.medium) {
                if showAll {
                    FilterChip(
                        label: String(localized: "filter_all"),
                        emoji: "🛒",
                        isSelected: selectedCategory == nil
                    ) {
                        withAnimation(.easeInOut) { selectedCategory = nil }
                    }
                    .accessibilityIdentifier(Constants.AccessibilityID.filterAll(parentID))
                }

                ForEach(ShoppingCategory.allCases, id: \.self) { category in
                    FilterChip(
                        label: category.localizedName,
                        emoji: category.emoji,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut) {
                            if showAll {
                                selectedCategory = selectedCategory == category ? nil : category
                            } else {
                                selectedCategory = category
                            }
                        }
                    }
                    .accessibilityIdentifier(Constants.AccessibilityID.filterChip(parentID, category.rawValue))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, Constants.Spacing.regular)
        }
    }
}
