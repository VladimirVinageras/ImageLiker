//
//  ProfileViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 17.02.2024.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    var userNameLabel = UILabel()
    var userLoginLabel = UILabel()
    var messageLabel = UILabel()
    var profileImage : UIImage?
    var imageView : UIImageView?
    var logOutButton : UIButton?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUserProfileImageView(systemNameImage: "person.crop.circle.fill")
        createLogoutButton(buttonImageSystemName: "ipad.and.arrow.forward")
        createUserNameLabel(userName: "Ekaterina Vinakheras")
        createUserLoginLabel(userLogin: "@ekaterina_vin")
        createMessageLabel(message: "Hello, IOS15!")
        activateConstraints()
        
    }
    
    private func createUserProfileImageView(systemNameImage : String){
        profileImage = UIImage(named: "profile")
        imageView = UIImageView(image: profileImage)
        guard let imageView = imageView else {return}
     //   imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    private func createUserNameLabel(userName: String){
        userNameLabel.text = userName
        userNameLabel.textColor = .ypWhite
            userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
    
       
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
    }
    private func createUserLoginLabel(userLogin: String){
        userLoginLabel.text = userLogin
     
            userLoginLabel.font = UIFont.systemFont(ofSize: 13)
               
        userLoginLabel.textColor = .ypGray
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLoginLabel)
    }
    
    private func createMessageLabel(message: String){
        
        messageLabel.text = message
        messageLabel.textColor = .ypWhite
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
    }
    
    private func createLogoutButton(buttonImageSystemName : String){
        logOutButton = UIButton.systemButton(
            with: UIImage(systemName: buttonImageSystemName)!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        guard let logOutButton = logOutButton else {return}
        logOutButton.tintColor = .red
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
    }
    
    private func activateConstraints(){
        guard let imageView = imageView else {return}
        guard let button = logOutButton else {return}
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userLoginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    
    @objc
    private func didTapButton(){
      print("I'll miss you 🥺")
    }
    
    
    
    
    
}


