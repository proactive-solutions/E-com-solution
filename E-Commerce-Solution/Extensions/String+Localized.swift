//
//  String+Localized.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import Foundation

extension String {
  func localize(comment: String? = nil) -> String {
    NSLocalizedString(self, comment: comment ?? "")
  }
}
