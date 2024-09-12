//
//  ProfilePresenter.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 18.04.2024.
//

import Foundation
import UIKit
import Kingfisher


final class ProfilePresenter : ProfilePresenterProtocol{
    
   weak var view: ProfileViewControllerProtocol?
    
    private let profileServiceShared = ProfileService.shared
    private let profileLogoutShared = ProfileLogoutService.shared
    private var oauth2tokenStorageShared = OAuth2TokenStorage.shared
   
    
    
     func updateAvatar() -> URL?{
        guard let profileImageURL = ProfileImageService.shared.profileImage,
              let url = URL(string: profileImageURL) else {return nil}
        return url
    }
    
        
    func updateProfileData()-> [String]? {
        guard let profileData = profileServiceShared.profileData else {return []}
        let name = profileData.name
        let loginName = profileData.loginName
        guard let bio = profileData.bio else {return nil}
        return [name, loginName, bio]

    }
    
    func cleanData() {
        profileLogoutShared.profileLogout()
    }
}
