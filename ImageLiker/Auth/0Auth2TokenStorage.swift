//
//  OAuth2TokenStorage.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 23.03.2024.
//

import Foundation


class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuthAccessToken"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
