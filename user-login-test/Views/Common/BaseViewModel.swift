//
//  BaseViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import Foundation
import RxSwift
import RxRelay

class BaseViewModel {
    
    var isLoading = BehaviorRelay(value: false)
    
    var alertErrorMessage = PublishSubject<String>()
    
}
