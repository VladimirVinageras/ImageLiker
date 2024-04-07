//
//  CustomNavigationViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 07.04.2024.
//

import Foundation
import UIKit

final class CustomNavigationViewController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        guard let preferredStatusBarStyle = topViewController?.preferredStatusBarStyle else { return .default}
        
        return  preferredStatusBarStyle
    }
}
