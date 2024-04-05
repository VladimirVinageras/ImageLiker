//
//  ProfileImageService.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 03.04.2024.
//

import Foundation
import UIKit

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService{
    static let shared = ProfileImageService()
    private init(){}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var profileImage: String?
    private let urlSession = URLSession.shared
    private var task : URLSessionTask?
    
    private var bearerTokenRequest: (String) -> String = { input in
        return "Bearer \(input)"
    }
    
    func createProfileImageURLRequest(with username : String, using authorizationToken: String) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL?.description else {
            assertionFailure("Failed to create URL")
            return nil
        }
        let urlRequest = defaultBaseURL + Constants.userUsernamePath + username
        guard let url = URL(string: urlRequest) else
        {
            assertionFailure("Invalid URL")
            return nil
        }
        
        var profileImageURLRequest = URLRequest(url: url)
        
        profileImageURLRequest.setValue(bearerTokenRequest(authorizationToken), forHTTPHeaderField: Constants.forHTTPHeaderField)
        return profileImageURLRequest
    }
    
    func fetchProfileImageURL(with username: String, using authorizationToken: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        task?.cancel()
        
        guard let profileImageURLRequest = createProfileImageURLRequest(with: username, using: authorizationToken) else {
            print("❌❌❌❌[ProfileImageServiceError.fetchProfileImageURL]: ProfileImageServiceError - Request ERROR \(ProfileImageServiceError.invalidRequest)")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: profileImageURLRequest) { (result: Result<ProfileImageResult, Error>) in
            switch result {
            case .success(let profileImageResult):
               
                if let profileImage = profileImageResult.profileImage {
                    guard let profileImageURL = profileImage.large else {return}
                    self.profileImage = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default                                     
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL])
                }
            case .failure(let error):
                print("❌❌❌❌[ProfileImageServiceError.objectTask]: ProfileImageServiceError - Request ERROR \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task.resume()
        
    }
    
}
