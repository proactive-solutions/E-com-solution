//
//  MainTabView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 14/09/25.
//

import SwiftUI
import UIComponents

// MARK: - Main Tab Bar View
struct MainTabView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          createTabItem(
            imageName: "house",
            selectedImageName: "house.fill",
            title: "Home"
          )
        }
        .tag(TabSelection.home)

      SearchView()
        .tabItem {
          createTabItem(
            imageName: "magnifyingglass",
            selectedImageName: "magnifyingglass",
            title: "Search"
          )
        }
        .tag(TabSelection.search)

      CartView()
        .tabItem {
          createTabItem(
            imageName: "cart",
            selectedImageName: "cart.fill",
            title: "Cart"
          )
        }
        .tag(TabSelection.cart)

      UserProfileView()
        .tabItem {
          createTabItem(
            imageName: "person",
            selectedImageName: "person.fill",
            title: "Profile"
          )
        }
        .tag(TabSelection.profile)
    }
    .tint(.blue) // Customize selected tab color
  }
}

// MARK: - Tab Selection Enum
enum TabSelection: CaseIterable {
  case home, search, cart, profile

  /// Returns the display title for each tab
  var title: String {
    switch self {
    case .home: return "Home"
    case .search: return "Search"
    case .cart: return "Cart"
    case .profile: return "Profile"
    }
  }
}

// MARK: - Tab Item Creation Helper
@ViewBuilder
private func createTabItem(
  imageName: String,
  selectedImageName: String,
  title: String
) -> some View {
  VStack {
    Image(systemName: imageName)
    Text(title)
  }
}

// MARK: - Individual View Components

struct UserProfileView: View {
  var body: some View {
    NavigationView {
      VStack {
        ProfileHeader()

        ProfileOptions()

        Spacer()
      }
      .navigationTitle("Profile")
    }
  }
}

// MARK: - Supporting Views

struct SearchResults: View {
  let query: String

  var body: some View {
    VStack {
      Text("Results for: \"\(query)\"")
        .font(.headline)
        .padding()

      // Add your search results implementation here
      Text("Search results would appear here")
        .foregroundColor(.secondary)
    }
  }
}

struct ProfileHeader: View {
  var body: some View {
    VStack {
      Image(systemName: "person.circle.fill")
        .font(.system(size: 80))
        .foregroundColor(.green)
        .padding()

      Text("John Doe")
        .font(.title2)
        .fontWeight(.semibold)

      Text("john.doe@example.com")
        .foregroundColor(.secondary)
        .padding(.bottom)
    }
  }
}

struct ProfileOptions: View {
  var body: some View {
    VStack(spacing: 16) {
      ProfileOptionRow(
        icon: "gear",
        title: "Settings",
        action: { print("Settings tapped") }
      )

      ProfileOptionRow(
        icon: "bell",
        title: "Notifications",
        action: { print("Notifications tapped") }
      )

      ProfileOptionRow(
        icon: "questionmark.circle",
        title: "Help & Support",
        action: { print("Help tapped") }
      )
    }
    .padding(.horizontal)
  }
}

#Preview {
  MainTabView()
}
