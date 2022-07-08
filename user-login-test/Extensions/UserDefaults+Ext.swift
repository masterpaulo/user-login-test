//
//  UserDefaults+Ext.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation

extension UserDefaults {
    
    static var currentUser: String? {
        get {
            return UserDefaults.standard.string(forKey: "user")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "user")
        }
    }
    
    static var registeredUsernames: [String] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "usernames") else { return [] }
            return (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false), forKey: "usernames")
        }
    }
    
}


