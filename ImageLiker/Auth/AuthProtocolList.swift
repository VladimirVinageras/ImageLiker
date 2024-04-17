//
//  AuthProtocolList.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 16.04.2024.
//

import Foundation
import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    
    func code(url: URL?) -> String?
}
