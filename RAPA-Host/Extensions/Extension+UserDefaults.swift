//
//  Extension+UserDefaults.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import Foundation



    
extension UserDefaults {
    private enum Keys {
        static let userAccount = "userAccount"
    }

    var userAccount: UserShape? {
        get {
            if let data = data(forKey: Keys.userAccount) {
                return try? JSONDecoder().decode(UserShape.self, from: data)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                set(data, forKey: Keys.userAccount)
            } else {
                removeObject(forKey: Keys.userAccount)
            }
        }
    }

}


