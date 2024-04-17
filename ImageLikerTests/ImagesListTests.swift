//
//  ImagesListTests.swift
//  ImageLikerTests
//
//  Created by Vladimir Vinakheras on 17.04.2024.
//

@testable import ImageLiker
import XCTest

final class ImagesListUnitTest: XCTestCase {
    
    func testDateToString() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        viewController.selfConfiguration(presenter)
        
        let formatter = ISO8601DateFormatter()
        guard let date =  formatter.date(from: "2022/08/31 22:31") else {return}
        
        //when
        let code = presenter.dateString(date)
        
        //then
        XCTAssertEqual(code, "31 August 2022")
    }
    
    func testInvalidDateToString() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        viewController.selfConfiguration(presenter)
        
        let formatter = ISO8601DateFormatter()
        guard let date =  formatter.date(from: "2022/08/31 22:31") else {return}
        
        //when
        let code = presenter.dateString(date)
        
        //then
        XCTAssertFalse(code == "30 августа 2022 г.")
    }
}

