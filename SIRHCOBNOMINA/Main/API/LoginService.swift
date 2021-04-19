//
//  LoginService.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 08/02/21.
//

import Foundation

struct LoginService {
    static var isAuthenticated = false
    
    static func loginWithUserName(userName:String,password:String, completionHandler:@escaping(_ user:MAuthenticate<MUser>? , _ error:String?)->Void )  {
        
        var user:MAuthenticate<MUser>?
        
        let body: NSMutableDictionary? = [
            "usuario": "\(userName)",
            "contrasena": "\(password)"]

        let url = NSURL(string: "http://54.184.232.181:3000/autenticar" as String)
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)

        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                completionHandler(nil,"UserResponse.UserResponseRequestFailed")
                return
            }
            
            guard let response = response as? HTTPURLResponse
                else {
                    print ("server response error")
                    completionHandler(nil,"UserResponse.UserResponseRequestFailed")
                    return
            }
            
            print(response.statusCode)
            
            var dataString2:String?
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\(dataString)")
                
                dataString2 =  dataString.replacingOccurrences(of: "null", with: "")
                
                print(dataString2)
                
            }
            
            
            if response.statusCode == 200{
                
                DispatchQueue.main.async {
                    
                do{
                    //                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    //
                    //                    print(json)
                    //
                    //                    let dictionary = json as! [String : AnyObject]
                    //
                    //                    print(dictionary["functionname"]!)
                    
                    //print(data!)
                    if let data = data {
                        
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    let context = appDelegate.persistentContainer.viewContext
                        //                            let persistentContainer:NSPersistentContainer
                                                    
                    let decoder = JSONDecoder()
                                                    
//                        guard let codingUserInfoManagedObjectContext = CodingUserInfoKey.managedObjectContext  else {
//                                                        fatalError("Failed to retrieve context")
//
//                        }
                                                    
//                        decoder.userInfo[codingUserInfoManagedObjectContext] = context
                        
                                                    
                        
                        user = try decoder.decode(MAuthenticate.self, from: data)
                        
                        isAuthenticated = true
//                            print(user)
                        
                        //                    print(user?.fullName)
                        
//                            try! User.save(user: user!)

                    }
                    else {
                        completionHandler(nil,"UserResponse.UserResponseInvalidData")
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                    completionHandler(nil,"UserResponse.UserResponseJSONConversionFailure")
                    return
                }
                    completionHandler(user,"UserResponse.UserResponseOK")
                    
                }
            }
            else  {
                completionHandler(nil,"UserResponse.UserResponseInvalidData")
            }
            
//                completionHandler(user,nil)
            
        }
        
        task.resume()
        
    }
}

