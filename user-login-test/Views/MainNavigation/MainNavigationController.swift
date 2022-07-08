//
//  MainNavigationController.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import UIKit
import RxSwift

/// Main navigation controller to display as a base screen
class MainNavigationController: UINavigationController {
    
    var vm: MainNavigationViewModel = MainNavigationViewModel()
    
    var bag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        if AuthService.shared.isLoggedIn {
            presentUserList()
        } else {
            presentLogin()
        }
    }
    
    private func createLogoutButton() -> UIBarButtonItem {
        UIBarButtonItem(title: "Logout",
                        style: .plain,
                        target: self,
                        action: #selector(logoutButtonAction(_:)))
    }
    
    @objc
    func logoutButtonAction(_ sender: Any) {
        vm.logout()
    }
    
}

// MARK: - Bind View Model

extension MainNavigationController {
    func bindViewModel() {
        vm.currentView.subscribe(onNext: { [weak self] view in
            switch view {
            case .login: self?.presentLogin()
            case .register: self?.presentRegister()
            case .userList: self?.presentUserList()
            case .userDetails(let user): self?.presentUserDetails(for: user)
            }
        }).disposed(by: bag)
    }
}

// MARK: - Presentation Functions

extension MainNavigationController {
    func presentLogin() {
        let vc = LoginViewController.instantiate(fromAppStoryboard: .main)
        vc.vm = LoginViewModel(loginResponder: vm)
        self.setViewControllers([vc], animated: false)
    }
    
    func presentRegister() {
        let vc = RegisterViewController.instantiate(fromAppStoryboard: .main)
        vc.vm = RegisterViewModel(registerResponder: vm)
        self.setViewControllers([vc], animated: false)
    }
    
    func presentUserList() {
        let vc = UserListViewController.instantiate(fromAppStoryboard: .user)
        vc.vm = UserListViewModel(userSelectionResponder: vm)
        vc.navigationItem.rightBarButtonItem = createLogoutButton()
        self.setViewControllers([vc], animated: false)
    }
    
    func presentUserDetails(for user: User) {
        // Initialize User Details VC using default UITableViewController init(style:)
        let vc = UserDetailsViewController(style: .grouped)
        vc.vm = UserDetailsViewModel(user: user)
        vc.navigationItem.rightBarButtonItem = createLogoutButton()
        self.pushViewController(vc, animated: true)
    }
}
