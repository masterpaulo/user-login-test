//
//  AppError.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import Alamofire

enum AppError: Error {
    case badRequest
    case unauthorized
    case validationFailed
    case serviceUnavailable
    case requestError(AFError)
    case notFound
}

extension AppError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Forbidden"
        case .validationFailed:
            return "Validation Failed"
        case .serviceUnavailable:
            return "Service Unavailable"
        case let .requestError(error):
            return error.localizedDescription
        case .notFound:
            return "Not found"
        }
    }
}
