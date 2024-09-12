//
//  ImagesListPresenter.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 17.04.2024.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private lazy var photoDateFormatterServiceShared = PhotoDateFormatterService.shared
    
    public func dateString(_ date: Date) -> String {
        guard let dateToReturn = photoDateFormatterServiceShared.formattingPhotoDate(with: date.description) else {return ""}
        return dateToReturn
    }
}

