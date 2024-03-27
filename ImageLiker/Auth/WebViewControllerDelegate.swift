//
//  WebViewControllerDelegate.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 16.03.2024.
//

import Foundation
import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
