//
//  HomeView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 14/09/25.
//
import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationView {
      VStack {
        Image(systemName: "house.fill")
          .font(.system(size: 60))
          .foregroundColor(.blue)
          .padding()

        Text("Welcome Home")
          .font(.title)
          .fontWeight(.semibold)

        Text("Your home content goes here")
          .foregroundColor(.secondary)
          .padding(.top, 8)

        Spacer()
      }
      .navigationTitle("Home")
    }
  }
}
