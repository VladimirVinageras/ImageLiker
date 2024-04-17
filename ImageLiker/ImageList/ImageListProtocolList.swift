//
//  ImageListProtocolList.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 17.04.2024.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func dateString(_ date: Date) -> String
}

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
