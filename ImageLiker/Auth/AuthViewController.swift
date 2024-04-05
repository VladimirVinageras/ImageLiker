//
//  AuthViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 15.03.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class AuthViewController : UIViewController{
    
    private let segueShowWebViewIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(using: code){ [weak self] result in
            guard let viewController = self  else {return}
                
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                viewController.storage.token = token
                viewController.delegate?.didAuthenticate(viewController)
               
                print("✅✅✅✅✅✅✅Received token: ", token)
                
            case .failure(let error):
                self?.prepareAlert()
                print("❌❌❌❌❌❌Failed to retrieve token:", error)
                break
            }
        }
    }
    
    private func prepareAlert(){
        let alert = UIAlertController(title: "Authorization Error", message: "Unable to login. Try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.present(self, animated: true)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

