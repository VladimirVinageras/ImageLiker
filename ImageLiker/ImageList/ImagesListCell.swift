//
//  ImageListCell.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 06.02.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageToLike: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    
    
    func gradientHandler() {
        let caGradientLayer = CAGradientLayer()
        caGradientLayer.frame = gradientView.bounds
        
        
        caGradientLayer.colors = [(UIColor.ypBlack).withAlphaComponent(0).cgColor, (UIColor.ypBlack).withAlphaComponent(0.2).cgColor]
      
        
        caGradientLayer.locations = [0.0, 1.0]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientView.layer.addSublayer(caGradientLayer)
    }
    
}
