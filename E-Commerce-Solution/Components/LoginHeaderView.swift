//
//  LoginHeaderView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Login Header Component

struct LoginHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // App Icon
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                )

            // Welcome Text
            VStack(spacing: 8) {
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Create your account to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
