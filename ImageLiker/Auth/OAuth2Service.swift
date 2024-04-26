//
//  OAuth2Service.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 20.03.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private var isFetchingOAuthTokenTasksRunning = false
    
    private init() {}
    
    private func createTokenRequest(using code: String) -> URLRequest? {
        guard let urlBase = Constants.baseURL else {return nil}
        let urlAuthToken = urlBase.description + Constants.oAuthTokenPath
        
        guard var urlComponents = URLComponents(string: urlAuthToken) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value:  Constants.accesKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(using code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("❌❌❌❌[OAuth2Service.fetchOAuthToken]: AuthServiceError - Request ERROR \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        if (ProcessInfo().arguments.contains("testMode")){
            if isFetchingOAuthTokenTasksRunning {
                return
            }
        }
        isFetchingOAuthTokenTasksRunning = true
        
        task?.cancel()
        lastCode = code
        
        
        guard let tokenRequest = createTokenRequest(using: code) else {
            print("❌❌❌❌[OAuth2Service.makeOAuthTokenRequest]: AuthServiceError - Request ERROR \(AuthServiceError.invalidRequest)")
            completion(
                .failure(
                    NSError(
                        domain: "OAuth2Service",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "ERROR: Failed to create token request"]
                            )
                        )
                    )
            return
        }
        
        let task = urlSession.objectTask(for: tokenRequest) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                
                guard let accessToken = data.accessToken else {return}
                completion(.success(accessToken))
                self.isFetchingOAuthTokenTasksRunning = false
            case .failure(let error):
                print("❌❌❌❌[OAuth2Service.objectTask]: Request ERROR \(error)")
                completion(.failure(error))
                self.isFetchingOAuthTokenTasksRunning = false
            }
            self.task = nil
            self.lastCode = nil
            
        }
        self.task = task
        task.resume()
        
    }
}

