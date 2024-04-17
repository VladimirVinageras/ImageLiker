//
//  ProfileImageResult.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 03.04.2024.
//

import Foundation

struct ProfileImageResultSize : Codable{
    var large : String?
    var medium : String?
    var small : String?
}

struct ProfileImageResult : Codable {
    var profileImage : ProfileImageResultSize?
    
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}
