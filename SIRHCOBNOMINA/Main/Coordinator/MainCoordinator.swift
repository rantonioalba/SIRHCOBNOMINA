//
//  Coordinator.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 25/02/21.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var children:[Coordinator] { get  }
    
    
    func start()
}


class MainCoordinator:Coordinator {
    var children: [Coordinator] = []
    
//    private let window: UIWindow
    
    private var user:MUser
        
    
    
    init(user:MUser){
        self.user = user
    }
    
    
    func start() {
        
                
        let navigationController = UINavigationController()
        
        let paySheetCoordinator = PaySheetCoordinator(navigationController: navigationController, user: user)
        
        children.append(paySheetCoordinator)
        
        paySheetCoordinator.start()
        
        if let window = UIApplication.shared.keyWindow {
        
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    
    }
}
