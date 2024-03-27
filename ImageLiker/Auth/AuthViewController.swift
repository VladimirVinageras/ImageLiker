//
//  AuthViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 15.03.2024.
//

import Foundation
import UIKit

final class AuthViewController : UIViewController{
    private let segueShowWebViewIdentifier = "ShowWebView"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(webViewViewControllerDidCancel(_:)))
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        let oauthService = OAuth2Service.shared
        
        oauthService.fetchOAuthToken(using: code) {[weak self] result in
            switch result {
            case .success(let token):
                print("Received token:", token)
              
            case .failure(let error):
                print("Failed to retrieve token:", error)
            }
        }
    }
    
    @objc func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("Let see what we have here")
        dismiss(animated: true)
    }
}
