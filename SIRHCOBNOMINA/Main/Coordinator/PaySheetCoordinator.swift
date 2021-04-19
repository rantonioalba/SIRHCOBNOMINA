//
//  PaySheetCoordinator.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 25/02/21.
//

import Foundation
import UIKit


final class PaySheetCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    var user : MUser
    
    
    init(navigationController:UINavigationController, user:MUser) {
        self.navigationController = navigationController
        self.user = user
    }
    
    func start() {
        let paySheetController = PaySheetViewController(nibName: "PaySheetViewController", bundle: nil)
        
        let viewModel = PaySheetViewModel()
        viewModel.user = user
        viewModel.coordinator = self
        
        paySheetController.viewModel = viewModel
        
        navigationController.setViewControllers([paySheetController], animated: true)
    }
    
    func startPaySheetDetail(paySheet:MPaySheet)  {
        let paySheetDetailCoordinator = PaySheetDetailCoordinator(navigationController: navigationController,paySheet: paySheet)
        
        children.append(paySheetDetailCoordinator)
        
        paySheetDetailCoordinator.parentCoordinator = self
        
        paySheetDetailCoordinator.start()
    }
    
    func childDidFinish(childCoordinator:Coordinator)  {
        
        if let index = children.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            children.remove(at: index)
        }
    }
}
