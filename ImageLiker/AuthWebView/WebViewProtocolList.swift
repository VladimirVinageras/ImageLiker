//
//  WebViewProtocols.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 16.04.2024.
//

import Foundation


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject{
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
        func setProgressHidden(_ isHidden: Bool)
}

public protocol WebViewPresenterProtocol{
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(url: URL?) -> String?
}


