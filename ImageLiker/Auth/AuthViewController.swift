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
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowWebViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(segueShowWebViewIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
        
    }
    
    @objc func backButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        oauth2Service.fetchOAuthToken(using: code){ [weak self] result in
            guard let delegate = self?.delegate, let viewController = self  else {return}
                delegate.didAuthenticate(viewController)
            
            switch result {
            case .success(let token):
                print("✅✅✅✅✅✅✅Received token: ", token)
                
            case .failure(let error):
                print("❌❌❌❌❌❌Failed to retrieve token:", error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

