//
//  WebViewPresenter.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 15.04.2024.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol{
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol){
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        loadAuthView()
        }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(url : URL?) -> String? {
        authHelper.code(url: url)
    }
    
}

// MARK: Private class methods

extension WebViewPresenter {
    private func loadAuthView(){
        guard let request = authHelper.authRequest() else {return}
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
}
