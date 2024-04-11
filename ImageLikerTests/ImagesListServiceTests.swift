//
//  ImageLikerTests.swift
//  ImageLikerTests
//
//  Created by Vladimir Vinakheras on 11.04.2024.
//
@testable import ImageLiker
import XCTest

final class ImageLikerTests: XCTestCase {

    func testExample(){
    }
    
    func testFetchPhotos() {
        let service = ImagesListService.shared
            
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
            
            service.fetchPhotosNextPage()
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }
    
    
}
