//
//  APIConfigurationProtocol.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation
import Alamofire

typealias APIParams = [String : Any]?

protocol APIConfigurationProtocol {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var parameters: APIParams { get }
    var url: URL { get }
}

extension APIConfigurationProtocol {
    
    var url: URL { try! K.API.baseURL.asURL() }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
       
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
       
       // HTTP Method
        urlRequest.httpMethod = method.rawValue

       // Parameters
        if let parameters = parameters {

            if self.method == .post {
                urlRequest.httpBody = self.parseParameters(parameters: parameters)
            } else if self.method == .get {
                return try URLEncoding.default.encode(urlRequest, with: self.parameters)
            }
        }
       
        return urlRequest
    }
    
    /// Parse parameters for POST data x-www-form-urlencoded
    ///
    /// - Parameters:
    ///   - parameters: Request parameters
    private func parseParameters(parameters: Parameters) -> Data? {

        let body = parameters.map{ "\($0.key)=\($0.value)" }.joined(separator: "&")

        return body.data(using: .utf8)
    }
}

