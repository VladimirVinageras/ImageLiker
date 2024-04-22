//
//  ProfileViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 17.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: (any ProfilePresenterProtocol)?
    
    private var userNameLabel = UILabel()
    private var userLoginLabel = UILabel()
    private var messageLabel = UILabel()
    private var profileImage : UIImage?
    private var imageView : UIImageView?
    private var logOutButton : UIButton?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        createUserProfileImageView(systemNameImage: "person.crop.circle.fill")
        createLogoutButton(buttonImageSystemName: "ipad.and.arrow.forward")
        createUserNameLabel(userName: "Ekaterina Vinakheras")
        createUserLoginLabel(userLogin: "@ekaterina_vin")
        createMessageLabel(message: "Hello, IOS15!")
        activateConstraints()
        presenter = ProfilePresenter()
        
    
        updateProfileData()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
            self?.updatingProfileImage()
                
            }
        
        self.updatingProfileImage()
    }
            
  private  func updatingProfileImage(){
        guard let presenter = presenter else {return}
        guard let imageView = imageView else {return}
        imageView.backgroundColor = .ypBlack
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        
        imageView.kf.indicatorType = .activity
        
        imageView.kf.setImage(
            with: self.updateAvatar(),
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor)])
    }
    
    func updateAvatar() -> URL?{
        presenter?.updateAvatar()
    }
    
    private func createUserProfileImageView(systemNameImage : String){
        profileImage = UIImage(named: "profile")
        imageView = UIImageView(image: profileImage)
        guard let imageView = imageView else {return}
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
        logOutButton.tintColor = .ypRed
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.accessibilityIdentifier = "logOutButton"
        view.addSubview(logOutButton)
    }
    
    private func activateConstraints(){
        guard let imageView = imageView else {return}
        guard let button = logOutButton else {return}
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
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
        guard let presenter = presenter else {return}
        logoutConfirmation()
    }
    
    private func logoutConfirmation(){
        let alertController = UIAlertController(
            title: "Пока,пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            cleanData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        
       self.present(alertController, animated: true, completion: nil)
        print(alertController.children.description)
    }
    
    func cleanData(){
        presenter?.cleanData()
    }
    
}


extension ProfileViewController {
    
func selfConfiguration(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
private func updateProfileData(){
    let profileData = updatingProfileData()
    userNameLabel.text = profileData[0]
    userLoginLabel.text = profileData[1]
        messageLabel.text = profileData[2]
    }
    
    func updatingProfileData() -> [String] {
        guard var profileData = presenter?.updateProfileData() else {return []}
        return profileData
    }
}




