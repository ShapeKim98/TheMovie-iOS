//
//  UserDefaults.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import Foundation

@propertyWrapper
struct UserDefaults<T> {
    typealias FDUserDefaults = Foundation.UserDefaults
    
    let key: String
    let defaultValue: T?
    
    init(forKey: String, defaultValue: T? = nil) {
        self.key = forKey
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get { (FDUserDefaults.standard.object(forKey: key) as? T) ?? defaultValue }
        set {
            if newValue == nil {
                FDUserDefaults.standard.removeObject(forKey: key)
            } else {
                FDUserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

enum UserDefaultsKey: String {
    case profileImage = "ProfileImage"
    case nickname = "Nickname"
}

extension String {
    static func userDefaults(_ key: UserDefaultsKey) -> String {
        key.rawValue
    }
}
