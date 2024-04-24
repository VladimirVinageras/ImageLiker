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
    private var lastLoadedPage = 0
    
    private func createImageListURLRequest(with authorizationToken: String, next_page : Int) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL,
              var urlComponents = URLComponents(url: defaultBaseURL.appendingPathComponent(Constants.photosPath), resolvingAgainstBaseURL: false) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        let page = String(next_page)
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: Constants.photos_per_page),
            URLQueryItem(name: "order_by", value: "latest")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var imageListURLRequest = URLRequest(url: url)
        imageListURLRequest.httpMethod = "GET"
        imageListURLRequest.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        
        return imageListURLRequest
    }
    
    func fetchPhotoNextPage(with autorizationToken: String, _ completion: @escaping (Result<[Photo], Error>) -> Void){
        
        let nextPage = lastLoadedPage + 1
        
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
                self.photos.append(contentsOf: photosList)
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
        let isTestingMode = ProcessInfo().arguments.contains("testMode")
        if (isTestingMode) && lastLoadedPage > 1{
            self.lastLoadedPage += 1
        }else{
            fetchPhotoNextPage(with: authorizationToken) { result  in
                switch result {
                case .success(let photos):
                    self.lastLoadedPage += 1
                    print("❇️❇️❇️❇️Fetched photos successfully:", photos)
                case .failure(let error):
                    
                    print("❌❌❌❌Failed to fetch photos:", error)
                }
            }
        }
    }
}

//MARK: - HANDLING PHOTO LIKES
extension ImagesListService {
    //В курсе, функция называется changeLike
    
    func toggleLikeState( photoId: String, isPhotoLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = storage.token else {return}
        var toggleLikeStateRequest : URLRequest?
        
        toggleLikeStateRequest = createLikeRequest(token, for: photoId, when: isPhotoLiked)
        
        guard let toggleLikeStateRequest = toggleLikeStateRequest else {return}
        
        
        let task = URLSession.shared.objectTask(for: toggleLikeStateRequest) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let photoLikeResult):
                let isPhotoLiked = photoLikeResult.photo?.liked_by_user ?? false
                if let photoIndex = self.photos.firstIndex(where: { $0.id == photoLikeResult.photo?.id }) {
                    
                    var photo = self.photos[photoIndex]
                    photo.liked_by_user = isPhotoLiked
                    
                    self.photos = replacingPhoto(in: self.photos, atPosition: photoIndex, with: photo)
                }
                print("The new photo state is: \(String(describing: isPhotoLiked))")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    private func replacingPhoto(in actualPhotos: [Photo], atPosition: Int, with newPhoto: Photo) -> [Photo] {
        var updatedPhotos = actualPhotos
        updatedPhotos.replaceSubrange(atPosition...atPosition, with: [newPhoto])
        return updatedPhotos
    }
    
    
    //MARK: - CREATING REQUESTS
    private func createLikeRequest(_ authorizationToken: String, for photoId: String, when isLiked: Bool) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL?.description else {
            assertionFailure("Failed to create URL")
            return nil
        }
        let slash = "/"
        let urlRequestString = defaultBaseURL + Constants.photosPath + slash + photoId + Constants.likePath
        guard let url = URL(string: urlRequestString) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var postLikeRequest = URLRequest(url: url)
        postLikeRequest.setValue(bearerTokenRequest(authorizationToken), forHTTPHeaderField: Constants.forHTTPHeaderField)
        postLikeRequest.httpMethod = isLiked ? "POST" : "DELETE"
        
        return postLikeRequest
        
    }
}

//MARK: - CLEANING DATA FOR LOGOUT SERVICE

extension ImagesListService{
    func cleaningData() {
        photos = []
        task?.cancel()
        task = nil
        lastLoadedPage = 0
    }
}



