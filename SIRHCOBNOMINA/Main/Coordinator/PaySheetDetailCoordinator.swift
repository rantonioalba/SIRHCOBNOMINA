//
//  PaySheetDetailCoordinator.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 26/02/21.
//

import UIKit

final class PaySheetDetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    var paySheet:MPaySheet
    
    var parentCoordinator : PaySheetCoordinator?
    
    
    
    init(navigationController:UINavigationController, paySheet:MPaySheet ) {
        self.navigationController = navigationController
        self.paySheet = paySheet
    }
    
    
    func start() {
        
        
        let paySheetDetailController = PaySheetDetailViewController(nibName: "PaySheetDetailViewController", bundle: nil)
        paySheetDetailController.modalPresentationStyle = .fullScreen
        
        let viewModel = PaySheetDetailViewModel()
        
        let navController = UINavigationController(rootViewController: paySheetDetailController)
        
        navController.modalPresentationStyle = .fullScreen
        
        
        viewModel.paySheet = paySheet
        
        viewModel.coordinator = self
        
        paySheetDetailController.viewModel = viewModel
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true, completion: nil)
    }
    
    func didFinishPaySheetDetail() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
        
    }
}
