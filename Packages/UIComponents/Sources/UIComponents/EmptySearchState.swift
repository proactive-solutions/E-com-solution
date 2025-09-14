//
//  EmptySearchState.swift
//  UIComponents
//
//  Created by Pawan Sharma on 15/09/25.
//

import SwiftUI

public struct EmptySearchState: View {
    public init() {}
    public var body: some View {
    VStack {
      Image(systemName: "magnifyingglass")
        .font(.system(size: 60))
        .foregroundColor(.gray)
        .padding()

      Text("Start Searching")
        .font(.title2)
        .fontWeight(.medium)
        .foregroundColor(.secondary)
    }
  }
}
