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
        var firstName = ""
        var lastName = ""
        
        if let first_Name = first_name {firstName = first_Name} else {firstName = ""}
        if let last_Name = last_name {  lastName = last_Name} else {lastName = ""}
        
        return firstName + " " + lastName
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
