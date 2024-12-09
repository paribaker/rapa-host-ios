//
//  Common.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 11/30/24.
//

import Foundation

struct PaginatedRes<T: Hashable & Codable>: Hashable, Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [T]?
}



func isDebugMode() -> Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

