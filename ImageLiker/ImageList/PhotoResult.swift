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
    var width : Int?
    var height : Int?
    var likes : Int?
    var liked_by_user: Bool?
    var description : String?
    var urls : PhotoUrlsResult?
}
