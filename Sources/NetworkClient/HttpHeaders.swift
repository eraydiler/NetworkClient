//
//  HttpHeaders.swift
//  TalkToGPT
//
//  Created by Eray Diler on 28.03.2023.
//

import Foundation

public struct HTTPHeaders {
    public typealias DictionaryType = [Key : Value]
    private var headers = DictionaryType()
    
    var description: String {
        return self.headers.description
    }
    
    public init(_ headers: DictionaryType = [:]) {
        self.headers = headers
    }
}

// https://www.swiftbysundell.com/articles/creating-custom-collections-in-swift/
extension HTTPHeaders: Collection {
    public typealias Index = DictionaryType.Index
    public typealias Element = DictionaryType.Element

    public var startIndex: Index { return headers.startIndex }
    public var endIndex: Index { return headers.endIndex }

    public subscript(index: Index) -> Element {
        get { return headers[index] }
    }
    
    public func index(after i: Index) -> Index {
        return headers.index(after: i)
    }
}

extension HTTPHeaders {
    public enum Key: Hashable, RawRepresentable {
        public typealias RawValue = String

        case accept
        case acceptEncoding
        case acceptLanguage
        case authorization
        case contentType
        case contentLength
        case other(String)
        
        public init?(rawValue: String) {
            switch rawValue {
            case "Accept":
                self = .accept
            case "Accept-Encoding":
                self = .acceptEncoding
            case "Accept-Language":
                self = .acceptLanguage
            case "Authorization":
                self = .authorization
            case "Content-Length":
                self = .contentLength
            case "Content-Type":
                self = .contentType
            default:
                self = .other(rawValue)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .accept:
                return "Accept"
            case .acceptEncoding:
                return "Accept-Encoding"
            case .acceptLanguage:
                return "Accept-Language"
            case .authorization:
                return "Authorization"
            case .contentLength:
                return "Content-Length"
            case .contentType:
                return "Content-Type"
            case .other(let string):
                return string
            }
        }
    }
    
    public typealias Value = String
}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            headers[key] = value
        }
    }
}

extension HTTPHeaders {
    public static var `default`: HTTPHeaders {
        return [
            .accept: "application/json",
            .acceptEncoding: "gzip;q=1.0, *;q=0.5",
            .contentType: "application/json"
        ]
    }
}

extension HTTPHeaders {
    public subscript(key: Key) -> Value? {
        get { headers[key] }
        set { headers[key] = newValue }
    }
    
    public mutating func add(_ value: Value, for key: Key) {
        headers[key] = value
    }
}
