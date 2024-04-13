//
//  SingleImageViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 22.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
   
    var imageFullSizeUrl : URL?
    
    var image : UIImage?{
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
            guard let image = image else {return}
            self.rescaleAndCenterImageInScrollView(image: image)
            
        }
    }
    //MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
   
    //MARK: - "Must be" functions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self

        prepareImageViewForPresentation()

    }
    //MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func didTapShareButton(_ sender: Any) {
       shareImage()
    }
    
}


//MARK: - EXTENSIONS

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.size.width)/2
        let halfHeight = (scrollView.bounds.size.height - imageView.frame.size.height)/2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
    }
}

extension SingleImageViewController {
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        // -Scaling Limits
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        // -Updating view
        view.layoutIfNeeded()
        
        // -Making scales calculations
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        // -Setting zoom scale
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        
        // -Updating view again
        scrollView.layoutIfNeeded()
        
        // -Centering
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
 }
}

extension SingleImageViewController {
    private func prepareImageViewForPresentation() {
        UIBlockingProgressHUD.show()
        self.imageView.kf.setImage(with: imageFullSizeUrl,
        placeholder: UIImage(named: "scribbleVariable")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {return}
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                assertionFailure("❌❌❌ [SingleImageViewController - prepareImageViewForPresentation]: Error: Trying to load image")
                showError()
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Не надо", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.prepareImageViewForPresentation()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func shareImage(){
        guard let image = imageView.image else {
                   return
               }
               let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
               activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
               present(activityViewController, animated: true, completion: nil)
    }
}



