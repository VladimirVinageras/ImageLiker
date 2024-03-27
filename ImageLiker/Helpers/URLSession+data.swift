//
//  URLSession+data.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 20.03.2024.
//

import Foundation

enum NetworkError: Error {  // 1
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                    return
                }
                
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                
                completionHandler(.success((data, httpResponse)))
            }
        }
    }
}
