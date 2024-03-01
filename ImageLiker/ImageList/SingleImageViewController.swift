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
            guard isViewLoaded else { return }
            imageView.image = image
            guard let image = image else { return }
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
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 1.5
        guard let image = image else { return }
        self.rescaleAndCenterImageInScrollView(image: image)
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let xOffset = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0)
        let yOffset = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDidZoom(scrollView)
    }
}

extension SingleImageViewController {
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController {
    private func shareImage(){
        guard let image = imageView.image else {
                   return
               }
               let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
               activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
               present(activityViewController, animated: true, completion: nil)
    }
}
