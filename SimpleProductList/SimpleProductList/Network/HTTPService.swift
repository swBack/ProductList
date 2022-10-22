//
//  HTTPService.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

enum HTTPResponseErorr: Error {
    case httpError(Int)
    case invalidRequest(String)
    case emptyResponse(String)
    case requestMakeFailur(String)
    case decodeError(String)
    case unknown(String)
}

protocol NetworkServiceable {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}

class HTTPService: NetworkServiceable {
    private var session: URLSessionConfiguration = {
        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 3000
        configure.timeoutIntervalForResource = 3000
        return configure
    }()
    
    func request<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        let (data , response) = try await URLSession.shared.data(for: request)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            let error = HTTPResponseErorr.unknown(request.url?.absoluteString ?? "")
            throw error
        }
        
        if isSucess(statusCode) {
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                let error = HTTPResponseErorr.decodeError(String(data: data, encoding: .utf8)!)
                throw error
            }
            return result
        }
        let error = HTTPResponseErorr.httpError(statusCode)
        throw error
    }
    
    private func isSucess(_ statusCode: Int) -> Bool {
        return (200...209).contains(statusCode)
    }
}


protocol HTTPServiceConfigurable {
    var baseURL: String { get }
    var method: String {get}
    var resource: String {get}
    
    var urlRequest: URLRequest{get}
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
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: baseURL + resource)!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
