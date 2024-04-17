//
//  ProfileResult.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 02.04.2024.
//

import Foundation
import UIKit

struct ProfileResult : Codable {
    var id : String
    var username : String
    var first_name : String?
    var last_name : String?
    var bio : String?
}
