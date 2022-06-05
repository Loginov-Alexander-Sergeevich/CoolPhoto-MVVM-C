//
//  DetailedInformationPhotoCoordinator.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit

protocol DetailedInformationPhotosCoordinatorProtocol {
    var childCoordinators: [Coordinator] {get set}
    var resultsRequest: PhotoSearchResultsRequest {get set}
    var detailInformationPhotoRealmModel: DetailInformationPhotoRealmModel {get set}
    init(navigationController: UINavigationController)
    init(navigationController: UINavigationController, resultsRequest: PhotoSearchResultsRequest)
    init(navigationController: UINavigationController, realmBD: DetailInformationPhotoRealmModel)
}

final class DetailedInformationPhotosCoordinator: Coordinator, DetailedInformationPhotosCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var resultsRequest: PhotoSearchResultsRequest
    var detailInformationPhotoRealmModel: DetailInformationPhotoRealmModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.resultsRequest = PhotoSearchResultsRequest(id: "", created_at: "", urls: ["": .none], user: User(firstName: "", lastName: "", location: ""))
        self.detailInformationPhotoRealmModel = DetailInformationPhotoRealmModel()

    }
    convenience init(navigationController: UINavigationController, resultsRequest: PhotoSearchResultsRequest) {
        self.init(navigationController: navigationController)
        self.resultsRequest = resultsRequest
    }
    
    convenience init(navigationController: UINavigationController, realmBD: DetailInformationPhotoRealmModel) {
        self.init(navigationController: navigationController)
        self.detailInformationPhotoRealmModel = realmBD
    }
    
    func start() {
        let detailedInformationPhotoViewController = DetailedInformationPhotosViewController()
        let detailedInformationPhotoViewModel = DetailedInformationPhotosViewModel()
        detailedInformationPhotoViewController.viewModel = detailedInformationPhotoViewModel
        detailedInformationPhotoViewModel.delegat = self

        navigationController.pushViewController(detailedInformationPhotoViewController, animated: true)
    }
}
