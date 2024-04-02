//
//  Request.swift
//  TalkToGPT
//
//  Created by Eray Diler on 24.03.2023.
//

import Foundation

public protocol NetworkRequest {
    var scheme: String { get set }
    var host: String { get set }
    var path: String { get set }
    var method: HttpMethod { get set }
    var body: HttpBody? { get set }
    var headers: HTTPHeaders { get set }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get set }
}

public extension NetworkRequest {
    static var encoder: JSONEncoder { .default }

    func dateDecodingStrategy(_ value: JSONDecoder.DateDecodingStrategy) -> Self {
        var newRequest = self
        newRequest.dateDecodingStrategy = value
        return newRequest
    }

    func keyDecodingStrategy(_ value: JSONDecoder.KeyDecodingStrategy) -> Self {
        var newRequest = self
        newRequest.keyDecodingStrategy = value
        return newRequest
     }

    func body(_ value: HttpBody) -> Self {
        var newRequest = self
        newRequest.body = value
        return newRequest
     }

    func host(_ value: String) -> Self {
        var newRequest = self
        newRequest.host = value
        return newRequest
     }

    func scheme(_ value: String) -> Self {
        var newRequest = self
        newRequest.scheme = value
        return newRequest
     }

    func method(_ value: HttpMethod) -> Self {
        var newRequest = self
        newRequest.method = value
        return newRequest
     }

    func headers(_ value: HTTPHeaders) -> Self {
        var newRequest = self
        newRequest.headers = value
        return newRequest
     }
}
    
extension JSONEncoder {
    public static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

open class Request: NetworkRequest {
    public var scheme: String
    public var host: String
    public var path: String
    public var method: HttpMethod
    public var body: HttpBody?
    public var headers: HTTPHeaders
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

    public init(path: String) {
        self.path = path
        self.scheme = "https"
        self.host = ""
        self.method = .get
        self.headers = HTTPHeaders.default
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .secondsSince1970
    }
}
