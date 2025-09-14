//
//  SubTitleText.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 28/07/2025.
//
import SwiftUI

public struct SubHeadingText: View {
    private let value: String

    public init(_ value: String) {
        self.value = value
    }

    public var body: some View {
        Text(value)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
}
