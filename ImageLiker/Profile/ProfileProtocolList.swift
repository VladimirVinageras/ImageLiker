//
//  ProfileProtocolList.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 18.04.2024.
//

import Foundation

public protocol ProfilePresenterProtocol{
    var view: ProfileViewControllerProtocol? {get set}
    
    func updateAvatar() -> URL?
    func updateProfileData() -> [String]?
    func cleanData()
}


public protocol ProfileViewControllerProtocol :  AnyObject {
    var presenter : ProfilePresenterProtocol? {get set}
}

