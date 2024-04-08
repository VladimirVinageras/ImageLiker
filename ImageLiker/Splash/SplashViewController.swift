//
//  SplashViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 26.03.2024.
//

import Foundation
import UIKit
import ProgressHUD


final class SplashViewController : UIViewController {
    private let imageView = UIImageView()
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let profileServiceShared = ProfileService.shared
    private let profileImageServiceShared = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .ypBlack
        
        createSplashView()
        
        if let token = storage.token {
            fetchProfile(using: token)
        }  else {
            configAuthViewController()
        }
    }
    
    private func createSplashView(){
        
        imageView.image = UIImage(named: "Vector")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        
    }
    
    private func configAuthViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewNavigationController") as? UINavigationController
        guard let navigationViewController else { return }
        navigationViewController.modalPresentationStyle = .fullScreen
        let authViewController = navigationViewController.viewControllers[0] as? AuthViewController
        authViewController?.delegate = self
        present (navigationViewController, animated: true)
    
    }
    
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(using token: String) {
        UIBlockingProgressHUD.show()
        profileServiceShared.fetchProfile(using: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profileData):
                
                switchToTabBarController()
                profileImageServiceShared.fetchProfileImageURL(with: profileData.username, using: token) { result in }
                
            case .failure(let error):
                print("❌❌❌❌ [SplashViewController.fetchProfile]: RequestError \(error)")
                assertionFailure("Invalid profile data request: \(error)")
                break
            }
        }
        
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true){ [weak self] in
            guard let self = self , let token = storage.token  else { return }
            self.fetchProfile(using: token)
        }
    }
}




