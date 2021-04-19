//
//  UserViewModel.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 08/02/21.
//

import Foundation

class UserViewModel {
    private var user = MUser()
    
    var userName:String {
        return user.name ?? ""
    }
    
    var password:String {
        return user.password ?? ""
    }
}


extension UserViewModel {
    func updateUserName(userName:String)  {
        user.name = userName
    }
    
    func updatePassword(password:String)  {
        user.password = password
    }
    
    func login(completionHandler:@escaping(_ user:MUser?, _ error:String?)->Void)  {
        LoginService.loginWithUserName(userName: userName, password: password) { (user:MAuthenticate<MUser>?, error:String?) in
            
            if let user = user {
                print(user)
                
                completionHandler(user.body.first, nil)
            } else {
                completionHandler(nil,error)
            }
        }
    }
}
