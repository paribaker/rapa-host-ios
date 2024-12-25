//
//  User.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/1/24.
//

import Foundation


public struct UserShape: Hashable,Codable {
    public var id: String
    public var email: String
    public var firstName: String
    public var lastName: String
    public var token: String?

}


public struct LoginShape: Hashable, Codable {
    public var email: String
    public var password: String
}

