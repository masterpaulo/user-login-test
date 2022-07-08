//
//  LoginViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel: BaseViewModel {
    
    var authService = AuthService()
    
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest(username, password) { username, password in
            guard !username.isBlank && !password.isBlank else {
                return false
            }
            return username.isValidUsername && password.isValidPassword
        }
    }
    
    // MARK: - Responders
    
    var loginResponder: LoginResponder?
    
    // MARK: - init
    
    init(loginResponder: LoginResponder) {
        self.loginResponder = loginResponder
    }
    
    // MARK: - Methods
    
    func login() {
        // Validate form data
        authService.login(username: self.username.value, password: self.password.value) { [weak self] result in
            switch result {
            case .success:
                self?.loginResponder?.didLogin()
            case .failure(let error):
                guard let message = error.errorDescription else { return }
                self?.alertErrorMessage.onNext(message)
            }
        }
    }
    
}
