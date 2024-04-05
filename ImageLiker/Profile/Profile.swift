//
//  Profile.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 02.04.2024.
//

import Foundation
import UIKit

struct Profile : Codable {
 
    var loginName : String {
       return "@\(username)"
    }
    
    var name : String {
            guard let first_name = first_name,
                  let last_name = last_name
            else {
                return "Unknown name"
            }
            
            return first_name + " " + last_name
    }
    var biography : String {
        guard let bio = self.bio else {return "No information available"}
    return bio
    }
    
   //MARK: - Data from REQUEST Struct Result
    var username : String
    var first_name : String?
    var last_name : String?
    var bio : String?
    var id : String?
}
