//
//  APIManager+UserRoutes.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import Alamofire

/// Routes defined to acces `User` resource from API
private enum UserRoutes: URLRequestConvertible, APIConfigurationProtocol {

    // MARK: - Routes
    case getUsers
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getUsers: return .get
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getUsers: return "/users"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getUsers: return nil
        }
    }
}


/// Convenience methods for accessing `User` routes from API
extension APIManager {
    /// Get list of users from backend API
    ///
    /// - Parameters:
    ///   - completion: A callback closure retruning the result when the request has completed
    ///
    func getUserList(completion: @escaping (Result<[User], AppError>)->Void) {
        request(route: UserRoutes.getUsers, completion: completion)
    }
}
