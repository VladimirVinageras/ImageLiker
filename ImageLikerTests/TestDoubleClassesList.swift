//
//  TestDoubleClassesList.swift
//  ImageLikerTests
//
//  Created by Vladimir Vinakheras on 16.04.2024.
//

import ImageLiker
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageLiker.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(url: URL?) -> String? {
        return nil
    }

}


final class ProfilePresenterSpy: ProfilePresenterProtocol{
    var view: ProfileViewControllerProtocol?
    var didCalledUpdateAvatar = false
    var didCalledUpdateProfileData = false
    var didCalledCleanData = false
    
    func updateAvatar() -> URL?{
        didCalledUpdateAvatar = true
        return nil
    }
    func updateProfileData() -> [String]?{
        didCalledUpdateProfileData = true
        return nil
    }
    func cleanData(){
        didCalledCleanData = true
    }
}
