//
//  SplashViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 26.03.2024.
//

import Foundation
import UIKit
final class SplashViewController : UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    
    
    
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
         switchToTabBarController()
    }
    
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            oauth2Service.fetchOAuthToken(using: code){ [weak self] result in
                switch result {
                case .success(let token):
                    print("✅✅✅✅✅✅✅Received token: ", token)
                    self?.switchToTabBarController()
                    
                case .failure(let error):
                    print("❌❌❌❌❌❌Failed to retrieve token:", error)
                }
            }
        }
    }
}


extension SplashViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}




