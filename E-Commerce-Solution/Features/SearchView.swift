//
//  SearchView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 14/09/25.
//
import SwiftUI
import UIComponents

struct SearchView: View {
  @State private var searchText = ""

  var body: some View {
    NavigationView {
      VStack {
        SearchBar(text: $searchText)
          .padding(.horizontal)

        if searchText.isEmpty {
          EmptySearchState()
        } else {
          SearchResults(query: searchText)
        }

        Spacer()
      }
      .navigationTitle("Search")
    }
  }
}
