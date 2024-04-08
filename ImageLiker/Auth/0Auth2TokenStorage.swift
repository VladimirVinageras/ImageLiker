//
//  OAuth2TokenStorage.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 23.03.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "OAuthAccessToken"
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else { return }
            keychainWrapper.set(token, forKey: tokenKey)
        }
    }
}
