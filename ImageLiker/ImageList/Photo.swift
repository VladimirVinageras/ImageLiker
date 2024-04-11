//
//  Photo.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 09.04.2024.
//

import Foundation

struct Photo : Codable {
    var id: String?
    var size: CGSize? {
        guard let width = width,
              let height = height else {return CGSize(width: 200, height: 200)}
        
        let sizeWidth = Double(width)
        let sizeheight = Double(height)
        return CGSize(width: sizeWidth, height: sizeheight)
    }
    
    var createdAt: String? {
        return created_at
    }
    var welcomeDescription: String?{
        return description
    }
    var thumbImageURL: String?{
        return urls?.thumb
    }
    
    var largeImageURL: String? {
        return urls?.full
    }
    var isLiked: Bool? {
        guard let isLikedBool = liked_by_user else {return false}
        return isLikedBool
    }
    
    var created_at: String?
    var width : Int?
    var height : Int?
    var liked_by_user: Bool?
    var description : String?
    var urls : PhotoUrlsResult?
    
}
