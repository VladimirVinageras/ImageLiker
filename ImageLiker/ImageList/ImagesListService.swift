//
//  ImagesListService.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 09.04.2024.
//

import Foundation
import UIKit

enum ImagesListServiceError: Error{
    case invalidRequest
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    
    private(set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    private var bearerTokenRequest: (String) -> String = { input in
        return "Bearer \(input)"
    }
    private var lastLoadedPage: Int?
    
    
    
    private func createImageListURLRequest(next_page : Int) -> URLRequest? {
        guard let authorizationToken = storage.token,
              let defaultBaseURL = Constants.defaultBaseURL?.description else {
            assertionFailure("Failed to create URL")
            return nil
        }
        let urlRequest = defaultBaseURL + Constants.photosPath
        guard let url = URL(string: urlRequest) else
        {
            assertionFailure("Invalid URL")
            return nil
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {return URLRequest(url: url)}
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: next_page.description),
            URLQueryItem(name: "per_page", value: Constants.photos_per_page),
            URLQueryItem(name: "order_by", value: "latest")
            
        ]
        var imageListURLRequest = URLRequest(url: url)
        
        imageListURLRequest.setValue(bearerTokenRequest(authorizationToken), forHTTPHeaderField: Constants.forHTTPHeaderField)
        
        return imageListURLRequest
    }
    
    func fetchPhotoNextPage(_ completion: @escaping (Result<Array<Photo>, Error>) -> Void){
    //    let authorizationToken = storage.token
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        task?.cancel()
        
        guard let ImageListURLRequest = createImageListURLRequest(next_page: nextPage) else {
            print("❌❌❌❌[ImageListServiceError.fetchImageListURL]: ImageListServiceError - Request ERROR \(ImagesListServiceError.invalidRequest)")
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: ImageListURLRequest) { (result: Result<Array<Photo>, Error>) in
            switch result {
            case .success(let photosListResult):
                
                var photosList = [Photo]()
                for item in photosListResult {
                    guard let id = item.id else {return}
                    guard let width = item.width else {return}
                    guard let heigth = item.heigth else {return}
                    guard let createdAt = item.created_at else {return}
                    guard let description = item.description else {return}
                    guard let isLikedString = item.liked_by_user else {return}
                    
                    let photo = Photo(id: id, created_at: createdAt, width: width,heigth: heigth, liked_by_user: isLikedString, description: description, urls: item.urls)
                    
                
                    photosList.append(photo)
                    print("❇️❇️❇️❇️❇️❇️ \(String(describing: photo.largeImageURL))")
                }
                self.photos = photosList
                completion(.success(photosList))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.photos])
            case .failure(let error):
                print("❌❌❌❌[ImageListServiceError.objectTask]: ImageListServiceError - Request ERROR \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task.resume()
        
    }
}
