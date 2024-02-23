//
//  SingleImageViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 22.02.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image : UIImage?{
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
