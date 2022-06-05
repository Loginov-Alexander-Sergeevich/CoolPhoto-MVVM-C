//
//  PhotoCollectionCoordinator.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit

protocol PhotoCollectionCoordinatorProtocol: AnyObject {
    func onSelect(resultsRequest: PhotoSearchResultsRequest)
}

final class SearchPhotoCoordinator: Coordinator, PhotoCollectionCoordinatorProtocol {
    private(set) var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let photoCollectionViewController = SearchPhotosViewController()
        photoCollectionViewController.delegate = self
        let photoCollectionViewModel = SearchPhotoViewModel()
        photoCollectionViewController.viewModel = photoCollectionViewModel

        navigationController.pushViewController(photoCollectionViewController, animated: true)
    }
    
    func onSelect(resultsRequest: PhotoSearchResultsRequest) {
        let detailedInformationPhotoCoordinator = DetailedInformationPhotosCoordinator(navigationController: navigationController, resultsRequest: resultsRequest)
        
        childCoordinators.append(detailedInformationPhotoCoordinator)
        
        detailedInformationPhotoCoordinator.start()
    }
    

}
