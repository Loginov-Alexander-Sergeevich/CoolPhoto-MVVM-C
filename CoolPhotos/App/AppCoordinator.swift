//
//  AppCoordinator.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: NSObject, Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func childDidFinish(_ childCoordinator: Coordinator) {
        
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
        // Проверь содержит ли массив контроллер контроллер DetailedInformationPhotoViewController
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        if let detailedInformationPhotoViewController = fromViewController as? DetailedInformationPhotosViewController {
            self.childDidFinish(detailedInformationPhotoViewController.viewModel?.delegat as! Coordinator)
        }
    }
}
