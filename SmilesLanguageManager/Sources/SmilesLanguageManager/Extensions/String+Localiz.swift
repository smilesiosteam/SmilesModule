//
//  String+Helpers.swift
//  House
//
//  Created by Hanan Ahmed on 11/2/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public extension String {

  ///
  /// Localize the current string to the selected language
  ///
  /// - returns: The localized string
  ///
  func localiz(comment: String = "") -> String {
      return SmilesLanguageManager.shared.getLocalizedString(for: self)
  }

}
