//
//  ImageLikerUITests.swift
//  ImageLikerUITests
//
//  Created by Vladimir Vinakheras on 19.04.2024.
//
@testable import ImageLiker
import XCTest

final class ImageLikerUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchArguments = ["testMode"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    //IMPORTANT: - Before running testAuth(), erase All content and Settings in your Simulator (Simulator -> Device -> Erase All Content and Settings...)
    func testAuth() throws {
      
            app.buttons["Authenticate"].tap()
            let webView = app.webViews["UnsplashWebView"]
            XCTAssertTrue(webView.waitForExistence(timeout: 5))
            
            
            let loginTextField = webView.descendants(matching: .textField).element
            XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
            loginTextField.tap()
            loginTextField.typeText("<Your_email>")
            loginTextField.swipeUp()
            
            
            let passwordTextField = webView.descendants(matching: .secureTextField).element
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
            
            passwordTextField.tap()
            passwordTextField.typeText("<Your_password>")
            webView.swipeUp()
            
            let webViewsQuery = app.webViews
            webViewsQuery.buttons["Login"].tap()
            sleep(2)
            
            let tablesQuery = app.tables
            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
            XCTAssertTrue(cell.waitForExistence(timeout: 5))

    }
    
    func testFeed() throws {
       //  тестируем сценарий ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
       XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 3))
        
        cellToLike.buttons["likeButton"].tap()
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 3))
        
        cellToLike.tap()
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["BackButton"]
        navBackButton.tap()
        
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 1))
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["<@Your_username>"].exists)
        XCTAssertTrue(app.staticTexts["<Your_Bio> || <Your Name>"].exists)
        
        app.buttons["logOutButton"].tap()
        app.alerts["Пока,пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        let button = app.buttons["Authenticate"]
        XCTAssertTrue(button.waitForExistence(timeout: 3))
        
    
        
    }
}
