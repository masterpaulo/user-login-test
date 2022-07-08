//
//  String+Validation.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation

extension String {
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    // Validate Username
    var isValidUsername: Bool {
        return isAlphanumeric && self.count >= 3
    }
    
    // Validate Password
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
