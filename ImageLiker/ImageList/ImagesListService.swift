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
    
    
    
    private func createImageListURLRequest(with authorizationToken: String, next_page : Int) -> URLRequest? {
           guard let defaultBaseURL = Constants.defaultBaseURL?.description else {
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
        imageListURLRequest.httpMethod = "GET"
        
        return imageListURLRequest
    }
    
    func fetchPhotoNextPage(with autorizationToken: String, _ completion: @escaping (Result<[Photo], Error>) -> Void){
    
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        task?.cancel()
        
        guard let ImageListURLRequest = createImageListURLRequest(with: autorizationToken, next_page: nextPage) else {
            print("❌❌❌❌[ImageListServiceError.fetchImageListURL]: ImageListServiceError - Request ERROR \(ImagesListServiceError.invalidRequest)")
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: ImageListURLRequest) { (result: Result<[PhotoResult],Error>) in
            switch result {
            case .success(let photosListResult):
                
                var photosList = [Photo]()
                for item in photosListResult {
                    let id = item.id
                    let width = item.width
                    let height = item.height
                    let createdAt = item.created_at
                    let description = item.description
                    let isLikedString = item.liked_by_user
                    
                    let photo = Photo(id: id, created_at: createdAt, width: width,height: height, liked_by_user: isLikedString, description: description, urls: item.urls)
                    
                
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


extension ImagesListService {
    func fetchPhotosNextPage() {
        guard let authorizationToken = storage.token else {return}
            
        fetchPhotoNextPage(with: authorizationToken) { result  in
                switch result {
                case .success(let photos):
                    
                    print("❇️❇️❇️❇️Fetched photos successfully:", photos)
                case .failure(let error):
                    
                    print("❌❌❌❌Failed to fetch photos:", error)
                }
            }
        }
}



