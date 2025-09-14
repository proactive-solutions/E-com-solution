//
//  ProfileOptionRow.swift
//  UIComponents
//
//  Created by Pawan Sharma on 15/09/25.
//

import SwiftUI

public struct ProfileOptionRow: View {
    public init(icon: String, title: String, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.action = action
    }
    
    public let icon: String
    public let title: String
    public let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
