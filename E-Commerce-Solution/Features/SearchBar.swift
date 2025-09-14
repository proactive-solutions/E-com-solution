//
//  SearchBar.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 14/09/25.
//
import SwiftUI

struct SearchBar: View {
  @Binding var text: String

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.secondary)

      TextField("Search...", text: $text)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }
}
