//
//  Response.swift
//  TalkToGPT
//
//  Created by Eray Diler on 20.04.2023.
//

import Foundation

protocol NetworkResponse {
    associatedtype T: Codable
    var payload: T { get }
    var data: Data { get }
}

public struct Response<T: Codable>: NetworkResponse {
    let payload: T
    let data: Data
}
