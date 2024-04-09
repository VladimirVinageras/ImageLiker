//
//  PhotoResult.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 09.04.2024.
//

import Foundation

struct PhotoResult : Codable{
    var id : String?
    var created_at: String?
    var width : String?
    var heigth : String?
    var likes : String?
    var liked_by_user: String?
    var description : String?
    var urls : PhotoUrlsResult?
}
