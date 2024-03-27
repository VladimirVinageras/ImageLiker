//
//  Constants.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 13.03.2024.
//

import Foundation

enum Constants {
    static let accesKey = "yMxRVH_hS5Vyd5cyOawCA9lRyzTqMu-Z8KcOV4qXUGo"
    static let secretKey = "zZaBoyLCz4A1xY-rhM0QjQzPcTdvKYauBu-Gz7IFjNc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accesScope = ""
    static let defaultBaseAPIURL = URL(string: "https://api.unsplash.com/")
    static let baseURL = URL(string: "https://unsplash.com/")
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let oAuthTokenPath = "/oauth/token"
    
}
