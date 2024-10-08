//
//  OAuthTokenResponseBody.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 23.03.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
