//
//  ViewController.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 03.02.2024.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }


}

//MARK: - DATASOURCE extension
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            cell = reusedCell
        } else{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = "Images and hearts here"

        return cell
    }
    
    // Здесь будут наши методы dataSource
}

//MARK: - DELEGATE extension
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let alert = UIAlertController(title: nil,
                                          message: "Вы нажали на строчку \(indexPath.row + 1)",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
    
    }
    
    
}

