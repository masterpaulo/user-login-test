//
//  RegisterViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import RxSwift
import RxRelay

class RegisterViewModel: BaseViewModel {
    
    var authService = AuthService()
    
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var confirmPassword = BehaviorRelay<String>(value: "")
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest(username, password, confirmPassword) { username, password, confirmPassword in
            guard !username.isBlank && !password.isBlank, !confirmPassword.isBlank else {
                return false
            }
            return username.isValidUsername && password.isValidPassword && (password == confirmPassword)
        }
    }
    
    // MARK: - Responders
    
    var registerResponder: RegisterResponder?
    
    // MARK: - init
    
    init(registerResponder: RegisterResponder) {
        self.registerResponder = registerResponder
    }
    
    // MARK: - Methods
    
    func register() {
        // Validate form data
        authService.register(username: self.username.value, password: self.password.value, complete: { [weak self] result in
            switch result {
            case .success:
                self?.registerResponder?.didRegister()
            case .failure(let error):
                guard let message = error.errorDescription else { return }
                self?.alertErrorMessage.onNext(message)
            }
        })
    }
    
    
}

