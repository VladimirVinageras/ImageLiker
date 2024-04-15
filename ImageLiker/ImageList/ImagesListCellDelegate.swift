//
//  ImagesListCellDelegate.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 11.04.2024.
//

import Foundation


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
