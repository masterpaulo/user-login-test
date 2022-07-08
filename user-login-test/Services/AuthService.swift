//
//  AuthService.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidUsername
    case invalidPassword
    case accountAlreadyExist
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidUsername: return "Username not found"
        case .invalidPassword: return "Password incorrect"
        case .accountAlreadyExist: return "Username is already taken"
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}

final class AuthService {
    
    static let shared = AuthService()
    
    // MARK: - Constants
    
    static let passwordkKey = "Kpassowrd"
    
    // MARK: - Computed Properties
    
    var isLoggedIn: Bool { UserDefaults.currentUser != nil }
    
    // MARK: - Methods
    
    func login(username: String, password: String, complete: @escaping (Result<String, AuthError>) -> Void) {
        // Check UserDefaults if username exists
        guard UserDefaults.registeredUsernames.contains(where: {$0 == username}) else {
            complete(.failure(.invalidUsername))
            return
        }
        // Retrieve password data from Keychain using the username as identifier
        guard let data = KeychainHelper.standard.read(service: AuthService.passwordkKey, account: username),
              let storedPassword = String(data: data, encoding: .utf8) else {
            complete(.failure(.unknown))
            return
        }
        // Check if retrieved password matches entry
        guard password == storedPassword else {
            complete(.failure(.invalidPassword))
            return
        }
        // Login success, store username as current user in UserDefautls
        UserDefaults.currentUser = username
        complete(.success(username))
    }
    
    func register(username: String, password: String, complete: @escaping (Result<String, AuthError>) -> Void) {
        guard !UserDefaults.registeredUsernames.contains(where: {$0 == username}) else {
            complete(.failure(.accountAlreadyExist))
            return
        }
        // Save username to UserDefaults
        UserDefaults.registeredUsernames.append(username)
        
        // Save password to Keychain using the username as identifier
        let data = Data(password.utf8)
        KeychainHelper.standard.save(data, service: AuthService.passwordkKey, account: username)
        
        // Register success, store username as current user in UserDefautls
        UserDefaults.currentUser = username
        
        complete(.success(username))
    }
    
    func logout() {
        UserDefaults.currentUser = nil
    }
    
}
