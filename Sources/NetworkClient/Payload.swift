//
//  Payload.swift
//  TalkToGPT
//
//  Created by Eray Diler on 29.03.2023.
//

import Foundation

public protocol Payload: Codable { }

public struct NoPayload: Payload { }
