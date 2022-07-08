//
//  UserListViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import RxSwift


class UserListViewModel: BaseViewModel {
    
    var userList: [User] = []
    
    var apiManager: APIManager = APIManager.shared
    
    // MARK: - Responders
    
    var userSelectionResponder: UserSelectionResponder?
    
    // MARK: - Observables
    
    var didLoadUserList = PublishSubject<Void>()
    
    // MARK: - init
    init(userSelectionResponder: UserSelectionResponder?) {
        self.userSelectionResponder = userSelectionResponder
    }
    
    // MARK: - Setup
    func load() {
        getUserList()
    }
    
    // MARK: - Methods
    
    func selectUser(at index: Int) {
        let user = userList[index]
        userSelectionResponder?.didSelectUser(user)
    }
    
}

// MARK: - API Connections

extension UserListViewModel {
    func getUserList() {
        self.isLoading.accept(true)
        apiManager.getUserList { [weak self] result in
            self?.isLoading.accept(false)
            switch result {
            case .success(let userList):
                self?.userList = userList
                self?.didLoadUserList.onNext(())
            case .failure(let error):
                self?.alertErrorMessage.onNext(error.debugDescription)
            }
        }
    }
}
