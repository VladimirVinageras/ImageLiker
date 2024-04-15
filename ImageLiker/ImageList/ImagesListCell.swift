//
//  ImageListCell.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 06.02.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
   
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet weak var imageToLike: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    
    override func prepareForReuse() {
           super.prepareForReuse()
        
           imageToLike.kf.cancelDownloadTask()
       }
   
    @IBAction func likeButtonTapped(_ sender: Any) {
        
           delegate?.imageListCellDidTapLike(self)
        
        }
    
    
    func gradientHandler() {
        let caGradientLayer = CAGradientLayer()
        caGradientLayer.frame = gradientView.bounds
        
        
        caGradientLayer.colors = [(UIColor.ypBlack).withAlphaComponent(0).cgColor, (UIColor.ypBlack).withAlphaComponent(0.2).cgColor]
      
        
        caGradientLayer.locations = [0.0, 1.0]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientView.layer.addSublayer(caGradientLayer)
    }
    
    func setIsLiked(isLiked: Bool) {
        let isLiked = isLiked ? UIImage(named: "Active") : UIImage(named: "NoActive")
        likeButton.setImage(isLiked, for: .normal)
    }
    
}
