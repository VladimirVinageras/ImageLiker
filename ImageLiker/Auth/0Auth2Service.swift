//
//  OAuth2Service.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 20.03.2024.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    func createTokenRequest(using code: String) -> URLRequest? {
        guard var urlBase = Constants.baseURL else {return nil}
        var urlAuthToken = urlBase.description + Constants.oAuthTokenPath
        
        guard var urlComponents = URLComponents(string: urlAuthToken) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value:  Constants.accesKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { return nil}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(using code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let tokenRequest = createTokenRequest(using: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "ERROR: Failed to create token request"])))
            return
        }
        
        let task = URLSession.shared.data(for: tokenRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    guard let accessToken = tokenResponse.accessToken else {return}
                    completion(.success(accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
