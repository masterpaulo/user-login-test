//
//  MainNavigationViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import Foundation
import RxSwift

enum MainNavigationView {
    case login
    case register
    case userList
    case userDetails(user: User)
}

class MainNavigationViewModel {
    
    let currentView = BehaviorSubject<MainNavigationView>(value: .login)
    
    // MARK: - Methods
    
    private func changeViewState(to view: MainNavigationView) {
        currentView.onNext(view)
    }
    
    func logout() {
        AuthService.shared.logout()
        didLogout()
    }
}

// MARK: - LoginResponder

extension MainNavigationViewModel: LoginResponder {
    func didLogin() {
        // Do some setup after successful login if needed
        changeViewState(to: .userList)
    }
    
    func switchToRegister() {
        changeViewState(to: .register)
    }
}

// MARK: - RegisterResponder

extension MainNavigationViewModel: RegisterResponder {
    func didRegister() {
        // Do some setup after successful register if needed
        changeViewState(to: .userList)
    }
    
    func switchToLogin() {
        changeViewState(to: .login)
    }
}

// MARK: - LogoutResponder

extension MainNavigationViewModel: LogoutResponder {
    func didLogout() {
        changeViewState(to: .login)
    }
}

// MARK: - UserSelectionResponder

extension MainNavigationViewModel: UserSelectionResponder {
    func didSelectUser(_ user: User) {
        changeViewState(to: .userDetails(user: user))
    }
}
