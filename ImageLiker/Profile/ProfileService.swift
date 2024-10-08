//
//  ProfileService.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 02.04.2024.
//

import Foundation
import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService{
    static let shared = ProfileService()
    private init(){}
   
    private let urlSession = URLSession.shared
    
    private(set) var profileData : Profile?
    private var task: URLSessionTask?
    private var bearerTokenRequest: (String) -> String = { input in
        return "Bearer \(input)"
    }
    private var isFetchingProfileTasksRunning = false
    
    private func createProfileRequest(authorizationToken: String) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL?.description else {
            assertionFailure("Failed to create URL")
            return nil
        }
        let urlRequest = defaultBaseURL + Constants.profilePath
        guard let url = URL(string: urlRequest) else
        {
            assertionFailure("Invalid URL")
            return nil
        }
        var profileRequest = URLRequest(url: url)
        profileRequest.setValue(bearerTokenRequest(authorizationToken), forHTTPHeaderField: Constants.forHTTPHeaderField)
        profileRequest.httpMethod = "GET"
        return profileRequest
    }
    
    func fetchProfile(using authorizationToken: String, completion: @escaping (Result<Profile, Error>) -> Void){
        if (ProcessInfo().arguments.contains("testMode")){
            if isFetchingProfileTasksRunning {
                return
            }
        }
        isFetchingProfileTasksRunning = true
        task?.cancel()
        
        guard let profileRequest = createProfileRequest(authorizationToken: authorizationToken) else {
            print("❌❌❌❌[ProfileServiceError.fetchProfile]: ProfileServiceError - Request ERROR \(ProfileServiceError.invalidRequest)")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: profileRequest) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profileData = Profile(username: profileResult.username, first_name: profileResult.first_name, last_name: profileResult.last_name, bio: profileResult.bio, id: profileResult.id)
                self.profileData = profileData
                completion(.success(profileData))
                self.isFetchingProfileTasksRunning = false
            case .failure(let error):
                print("❌❌❌❌[ProfileServiceError.objectTask]: ProfileServiceError - Request ERROR \(error)")
                completion(.failure(error))
                self.isFetchingProfileTasksRunning = false
            }
            self.task = nil
        }
        task.resume()
    }
}

//MARK: - CLEANING DATA FOR LOGOUT SERVICE

extension ProfileService{
    func cleaningData() {
        profileData = nil
        task?.cancel()
        task = nil
    }
}
