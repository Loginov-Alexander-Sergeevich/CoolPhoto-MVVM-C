//
//  TabBarCoordinator.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = TabBarController()
        tabBarController.coordinator = self
        
        let weightConfigImage = UIImage.SymbolConfiguration(weight: .heavy)
        
        let favoritePhotosImage = UIImage(systemName: "heart.fill", withConfiguration: weightConfigImage)!
        let photoCollectionImage = UIImage(systemName: "heart", withConfiguration: weightConfigImage)!
        
        let photoCollectionNavigationController = UINavigationController()
        photoCollectionNavigationController.tabBarItem = UITabBarItem(title: "Коллекция фотографий", image: photoCollectionImage, tag: 0)
        let photoCollectionCoordinator = SearchPhotoCoordinator(navigationController: photoCollectionNavigationController)
        photoCollectionCoordinator.start()
        
        let favoriteNavigationController = UINavigationController()
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Любимые фото", image: favoritePhotosImage, tag: 1)
        let favoritePhotosCoordinator = FavoritePhotosCoordinator(navigationController: favoriteNavigationController)
        favoritePhotosCoordinator.start()
        

        tabBarController.viewControllers = [photoCollectionNavigationController, favoriteNavigationController]
        tabBarController.modalPresentationStyle = .custom
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
