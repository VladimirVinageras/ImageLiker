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
    static let accessScope = "public+read_user+write_likes+"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let baseURL = URL(string: "https://unsplash.com")
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let oAuthTokenPath = "/oauth/token"
    static let nativeAutorizationPath = "/oauth/authorize/native"
    
    static let profilePath = "/me"
    static let userUsernamePath = "/users/"
    static let photosPath = "/photos"
    
    static let forHTTPHeaderField = "Authorization"
    
    static let photos_per_page = "17"
    
    static let likePath = "/like"
    
    static let invalidKeyForSuccessfulLogout = "Invalid_key_For_Successful_Logout"
    
    static let authorizationLogin : String = "vvinageras@gmail.com"
    static let authorizationPassword : String = "1q2w3e4r"
}


struct AuthConfiguration{
    static var standard : AuthConfiguration{
        return AuthConfiguration(
            accesKey: Constants.accesKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            baseURL: Constants.baseURL,
            unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
            oAuthTokenPath: Constants.oAuthTokenPath,
            nativeAutorizationPath: Constants.nativeAutorizationPath,
            profilePath: Constants.profilePath,
            userUsernamePath: Constants.userUsernamePath,
            photosPath: Constants.photosPath,
            forHTTPHeaderField: Constants.forHTTPHeaderField,
            photos_per_page: Constants.photos_per_page,
            likePath: Constants.likePath,
            invalidKeyForSuccessfulLogout: Constants.invalidKeyForSuccessfulLogout
        )
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let defaultBaseURL: URL?
    let baseURL: URL?
    
    let unsplashAuthorizeURLString: String
    let oAuthTokenPath: String
    let nativeAutorizationPath: String
    let profilePath: String
    let userUsernamePath: String
    let photosPath: String
    let forHTTPHeaderField: String
    let photos_per_page: String
    let likePath: String
    let invalidKeyForSuccessfulLogout: String
    
    let authorizationLogin : String
    let authorizationPassword : String
    
    init(
        accesKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: URL?,
        baseURL: URL?,
        unsplashAuthorizeURLString: String,
        oAuthTokenPath: String,
        nativeAutorizationPath: String,
        profilePath: String,
        userUsernamePath: String,
        photosPath: String,
        forHTTPHeaderField: String,
        photos_per_page: String,
        likePath: String,
        invalidKeyForSuccessfulLogout:String
    ) {
        self.accessKey = accesKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.baseURL = baseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.oAuthTokenPath = oAuthTokenPath
        self.nativeAutorizationPath = nativeAutorizationPath
        self.profilePath = profilePath
        self.userUsernamePath = userUsernamePath
        self.photosPath = photosPath
        self.forHTTPHeaderField = forHTTPHeaderField
        self.photos_per_page = photos_per_page
        self.likePath = likePath
        self.invalidKeyForSuccessfulLogout = invalidKeyForSuccessfulLogout
        
        self.authorizationLogin = Constants.authorizationLogin
        self.authorizationPassword = Constants.authorizationPassword
    }
    
}
