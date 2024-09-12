//
//  ProfileTests.swift
//  ImageLikerTests
//
//  Created by Vladimir Vinakheras on 18.04.2024.
//

@testable import ImageLiker
import XCTest


final class ProfileTests: XCTestCase {
   
    func testProfilePresenterCallsAvatarURL() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.selfConfiguration(presenter)
        //when
        viewController.updateAvatar()
        
        //then
        XCTAssertTrue(presenter.didCalledUpdateAvatar) //behaviour verification
    }

    func testProfilePresenterCallsUpdateProfileData() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.selfConfiguration(presenter)
        //when
        viewController.updatingProfileData()
        
        //then
        XCTAssertTrue(presenter.didCalledUpdateProfileData) 
    }
    
    func testProfilePresenterCleanData() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.selfConfiguration(presenter)
        //when
        viewController.cleanData()
        
        //then
        XCTAssertTrue(presenter.didCalledCleanData)
    }
 
    func testProfileViewLogoutTokenIsEqualNil() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        viewController.selfConfiguration(presenter)
        
        //when
        presenter.cleanData()
        
        //then
        XCTAssertEqual(OAuth2TokenStorage().token, AuthConfiguration.standard.invalidKeyForSuccessfulLogout)
    }
    
    
    func testProfileChangedViewControllerAfterLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.cleanData()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        //then
        XCTAssertTrue(window.rootViewController?.isKind(of: SplashViewController.self) == true) //behaviour verification
    }
    
    
    
}

