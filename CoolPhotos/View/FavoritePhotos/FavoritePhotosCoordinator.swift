//
//  FavoritePhotosCoordinator.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import UIKit

protocol FavoritePhotosCoordinatorProtocol: AnyObject {
    func onSelect(itemRealmBD: DetailInformationPhotoRealmModel)
}

final class FavoritePhotosCoordinator: Coordinator, FavoritePhotosCoordinatorProtocol {
    private(set) var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoritePhotosViewController = FavoritePhotosViewController()
        let favoritePhotosViewModel = FavoritePhotosViewModel()
        favoritePhotosViewController.delegat = self
        favoritePhotosViewController.viewModel = favoritePhotosViewModel
        
        navigationController.pushViewController(favoritePhotosViewController, animated: true)
    }
    
    func onSelect(itemRealmBD: DetailInformationPhotoRealmModel) {
        let detailedInformationPhotosCoordinator = DetailedInformationPhotosCoordinator(navigationController: navigationController, realmBD: itemRealmBD)

        childCoordinators.append(detailedInformationPhotosCoordinator)

        detailedInformationPhotosCoordinator.start()
    }
}
