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
    var isSnowingHearts = false
    @IBOutlet weak var heartsFallingView: UIView!
    
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
    
    func fallingHearts() {
        for _ in 0..<50 {
            createFallingHeart()
        }
        
        
    }
    
    
    func createFallingHeart() {
        guard isSnowingHearts else {return}
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red
        imageView.layer.opacity = 0.3
        
        // Set a random starting position
        let xPosition = CGFloat.random(in: heartsFallingView.bounds.minX..<heartsFallingView.bounds.maxX)
        let yPosition = CGFloat.random(in: heartsFallingView.bounds.minY ..< heartsFallingView.bounds.maxY)
        imageView.frame = CGRect(x: xPosition, y: yPosition, width: 12, height: 12)
        
        heartsFallingView.addSubview(imageView)
        
        // Animation Falling
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = 4
        animation.speed = 0.5
        animation.fromValue = yPosition
        animation.toValue = heartsFallingView.bounds.maxY
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        imageView.layer.add(animation, forKey: "position.y")
        
        
       // Animation dissapearing
        let animationDisappear = CABasicAnimation(keyPath: "opacity")
        animationDisappear.duration = 4.0
        animationDisappear.speed = 1
        animationDisappear.fromValue = imageView.layer.opacity
        animationDisappear.toValue = 0.0
        animationDisappear.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationDisappear.fillMode = CAMediaTimingFillMode.forwards
        animationDisappear.isRemovedOnCompletion = true
        animationDisappear.repeatCount = 1
        imageView.layer.add(animationDisappear, forKey: "opacityAnimation")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            imageView.removeFromSuperview()
        }
    }
    
    func toggleButtonImage(){
        let isLikedButton = isSnowingHearts ? UIImage(named: "Active") : UIImage(named: "NoActive")
        likeButton.setImage(isLikedButton, for: .normal)
    }
    
    
    @IBAction func toggleLikesUnlikes(_ sender: Any) {
        isSnowingHearts.toggle()
        toggleButtonImage()
    }
    
}
