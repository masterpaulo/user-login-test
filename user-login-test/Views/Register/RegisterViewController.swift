//
//  RegisterViewController.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: BaseViewController {
    
    var vm: RegisterViewModel!
    
    var bag = DisposeBag()
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var usernameErrorLabel: UILabel! {
        didSet {
            usernameErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var passwordErrorLabel: UILabel! {
        didSet {
            passwordErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel! {
        didSet {
            confirmPasswordErrorLabel.isHidden = true
        }
    }
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Actions
    
    @IBAction func registerButotnAction(_ sender: Any) {
        vm.register()
    }
    
    @IBAction func switchLoginButotnAction(_ sender: Any) {
        vm.registerResponder?.switchToLogin()
    }
    
}

// MARK: - Bind View Model

extension RegisterViewController {
    func bindViewModel() {
        bindUsernameField()
        bindPasswordField()
        bindConfirmPasswordField()
        bindFormValidation()
        bindErrorAlert()
    }
    
    private func bindUsernameField() {
        usernameTextField.rx.text.orEmpty.bind(to: vm.username).disposed(by: bag)
        
        usernameTextField
            .rx
            .controlEvent([.editingDidEnd, .editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                guard let usernameText = self.usernameTextField.text, !usernameText.isBlank else {
                    self.usernameErrorLabel.isHidden = true
                    return
                }
                self.usernameErrorLabel.isHidden = usernameText.isValidUsername
            })
            .disposed(by: bag)
    }
    
    private func bindPasswordField() {
        passwordTextField.rx.text.orEmpty.bind(to: vm.password).disposed(by: bag)
        
        passwordTextField
            .rx
            .controlEvent([.editingDidEnd, .editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                guard let password = self.passwordTextField.text, !password.isBlank else {
                    self.passwordErrorLabel.isHidden = true
                    return
                }
                self.passwordErrorLabel.isHidden = password.isValidPassword
            })
            .disposed(by: bag)
    }
    
    private func bindConfirmPasswordField() {
        confirmPasswordTextField.rx.text.orEmpty.bind(to: vm.confirmPassword).disposed(by: bag)
        
        confirmPasswordTextField
            .rx
            .controlEvent([.editingDidEnd, .editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                guard let confirm = self.confirmPasswordTextField.text,
                      let password = self.passwordTextField.text,
                      !confirm.isBlank else {
                    self.confirmPasswordErrorLabel.isHidden = true
                    return
                }
                self.confirmPasswordErrorLabel.isHidden = confirm == password
            })
            .disposed(by: bag)
    }
    
    private func bindFormValidation() {
        vm.isValidForm.bind(to: registerButton.rx.isEnabled).disposed(by: bag)
        
        vm.isValidForm
            .map({ $0 ? UIColor.systemBlue : UIColor.lightGray })
            .bind(to: registerButton.rx.backgroundColor)
            .disposed(by: bag)
    }
    
    private func bindErrorAlert() {
        vm.alertErrorMessage.subscribe(onNext: { [weak self] message in
            self?.showAlert(title: nil, message: message)
        })
        .disposed(by: bag)
    }
}
