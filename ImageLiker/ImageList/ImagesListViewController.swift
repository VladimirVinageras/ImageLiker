//
//  ViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 03.02.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var photosList: [Photo] = []
    private let imagesListServiceShared = ImagesListService.shared
    private let photoDateFormatterServiceShared = PhotoDateFormatterService.shared
    private var imagesListServiceObserver : NSObjectProtocol?
    
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        
        imagesListServiceShared.fetchPhotosNextPage()
    }
    
    
    //MARK: - TABLEVIEW UPDATER
    
    private func updateTableViewAnimated() {
        let actualAmount = photosList.count
        let nextAmount = imagesListServiceShared.photos.count
        
        guard actualAmount != nextAmount else {return}
        photosList = imagesListServiceShared.photos
        
        tableView.performBatchUpdates {
            var indexPath: [IndexPath] = []
            for rowIndex in actualAmount..<nextAmount {
                indexPath.append(IndexPath(row: rowIndex, section: 0))
            }
            tableView.insertRows(at: indexPath, with: .automatic)
        }
    completion: {_ in}
    }
}

//MARK: - CELL CONFIGURATION

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let cellPhoto = photosList[indexPath.row]
        guard let thumbImageURLString = cellPhoto.thumbImageURL,
              let imageURL = URL(string: thumbImageURLString) else {return}
        
        cell.imageToLike.kf.indicatorType = .activity
        cell.imageToLike.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "scribbleVariable")
        ) { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let dateCreatedAt = cellPhoto.createdAt
        let isPhotoLiked = cellPhoto.isLiked
        let isLikedButton = isPhotoLiked ? UIImage(named: "Active") : UIImage(named: "NoActive")
        
        cell.likeButton.setImage(isLikedButton, for: .normal)
        cell.dateLabel.text = photoDateFormatterServiceShared.formattingPhotoDate(with: dateCreatedAt)
        cell.gradientHandler()
        cell.selectionStyle = .none
    }
}

//MARK: - DATASOURCE extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
              imagesListServiceShared.fetchPhotosNextPage()
          }
      }
}

//MARK: - DELEGATE extension
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        
  
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photosList[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = photosList[indexPath.row]
 
        UIBlockingProgressHUD.show()
        guard let photoId = photo.id else {return}
        imagesListServiceShared.toggleLikeState(photoId: photoId, isPhotoLiked: photo.isLiked) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case.success:
                self.photosList = self.imagesListServiceShared.photos
                cell.setIsLiked(isLiked: self.photosList[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case.failure:
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Something went wrong in Like changing")
            }
        }
    }
}

extension ImagesListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let singleImageViewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let photoFullSizeUrlString = photosList[indexPath.row].largeImageURL,
                  let photoFullSizeUrlString = URL(string: photoFullSizeUrlString) else {return}
        
            singleImageViewController.imageFullSizeUrl = photoFullSizeUrlString
           
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    

}
