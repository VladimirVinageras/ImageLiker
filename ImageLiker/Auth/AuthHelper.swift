//
//  AuthHelper.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 16.04.2024.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
  
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {return nil}
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL?{
        guard var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString) else {return nil}
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accesKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        return urlComponents.url
    }
    
    func code(url: URL?) -> String? {
        if
            let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == configuration.nativeAutorizationPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}


