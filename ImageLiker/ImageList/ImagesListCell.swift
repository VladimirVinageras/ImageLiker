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
}
