//
//  PhotoDateFormatterService.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 13.04.2024.
//

import Foundation


final class PhotoDateFormatterService {
    static let shared = PhotoDateFormatterService()
    private init(){}
    
    let dateFormatter = ISO8601DateFormatter()
    let dateToReturnFormatter = DateFormatter()
    
    func formattingPhotoDate(with dateToFormat: String?) -> String?{
        guard let dateToFormat = dateToFormat else {return nil}
        guard let dateToReturn = dateFormatter.date(from: dateToFormat) else {return nil}
        
        dateToReturnFormatter.dateFormat = "d MMMM yyyy"
        return dateToReturnFormatter.string(from: dateToReturn)
    }
    
}
