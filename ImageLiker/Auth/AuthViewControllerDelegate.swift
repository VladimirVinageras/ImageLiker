//
//  AuthViewControllerDelegate.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 26.03.2024.
//

import Foundation
import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
