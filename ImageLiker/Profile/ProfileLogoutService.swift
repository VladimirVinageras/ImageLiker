//
//  ProfileLogoutService.swift
//  ImageLiker
//
//  Created by Vladimir Vinakheras on 13.04.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }
    
    private var imageListServiceShared = ImagesListService.shared
    private var profileServiceShared = ProfileService.shared
    private var profileImageServiceShared = ProfileImageService.shared
    private var oAuth2TokenStorageShared = OAuth2TokenStorage.shared

    func profileLogout() {
        oAuth2TokenStorageShared.token = Constants.invalidKeyForSuccessfulLogout
        cleaningCookies()
        cleaningData()
        backToSplashViewController()
   }

   private func cleaningCookies() {
      // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
    
    
    private func cleaningData(){
        profileServiceShared.cleaningData()
        profileImageServiceShared.cleaningData()
        imageListServiceShared.cleaningData()
    }
    
 
    func backToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    

    
}
    
