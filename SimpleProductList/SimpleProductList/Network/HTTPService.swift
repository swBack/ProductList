//
//  HTTPService.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation
import Alamofire

enum HTTPResponseErorr: Error {
    case httpError(Int)
    case invalidRequest(String)
    case emptyResponse(String)
    case requestMakeFailur(String)
    case decodeError(String)
    case unknown(String)
}

protocol NetworkServiceable {
    func request<T: Decodable>(_ requestURL: URL, method: HTTPMethod) async throws -> T
}

class HTTPService: NetworkServiceable {
    private var session: Session = {
        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 3000
        configure.timeoutIntervalForResource = 3000
        return Session(configuration: configure)
    }()
        
    func request<T>(_ requestURL: URL, method: HTTPMethod = .get) async throws -> T where T : Decodable {
        return try await AF.request(requestURL,
                                    method: method,
                                    encoding : URLEncoding.default)
        .serializingDecodable()
        .value
    }
}


protocol HTTPServiceConfigurable {
    var baseURL: String { get }
    var method: String {get}
    var resource: String {get}
    
    var urlRequest: URL{get}
}

extension HTTPServiceConfigurable {
    var baseURL: String {
        return "http://d2bab9i9pr8lds.cloudfront.net"
    }
}

enum HTTPInitialization {
    case initialize
}

extension HTTPInitialization: HTTPServiceConfigurable {
    var method: String {
        return "get"
    }
    var resource: String {
        return "/api/home"
    }
    
    var urlRequest: URL {
        return URL(string: baseURL + resource)!
    }
}

enum Pagination {
    case fetch(Int)
}

extension Pagination: HTTPServiceConfigurable {
    var method: String {
        return "get"
    }
    
    var resource: String {
        return "/api/home/goods?"
    }
    
    var urlQuery:[URLQueryItem] {
        switch self {
        case .fetch(let lastId):
            return [URLQueryItem(name: "lastId", value: "\(lastId)")]
        }
    }
    
    var urlRequest: URL {
        var component = URLComponents(string: baseURL + resource)!
        component.queryItems = urlQuery
        return component.url!
    }
}
