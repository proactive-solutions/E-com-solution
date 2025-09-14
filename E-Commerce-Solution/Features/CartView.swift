//
//  CartView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 14/09/25.
//
import SwiftUI

struct CartView: View {
  var body: some View {
    NavigationView {
      VStack {
        Image(systemName: "cart.fill")
          .font(.system(size: 60))
          .foregroundColor(.orange)
          .padding()

        Text("Your Cart")
          .font(.title)
          .fontWeight(.semibold)

        Text("Cart items will appear here")
          .foregroundColor(.secondary)
          .padding(.top, 8)

        Spacer()
      }
      .navigationTitle("Cart")
    }
  }
}
