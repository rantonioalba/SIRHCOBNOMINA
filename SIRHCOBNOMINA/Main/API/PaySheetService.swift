//
//  PaySheetService.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 18/02/21.
//

import Foundation

struct PaySheetService {
    
    static func getPaySheet(token:String, completionHandler: @escaping(_ paySheet: MAuthenticate<MPaySheet>?, _ error:String?)->Void)  {
        
        var objects:MAuthenticate<MPaySheet>?
        
        let url = NSURL(string: "http://54.184.232.181:3000/nominas" as String)
        var request = URLRequest(url: url! as URL)
        
        
        request.httpMethod = "GET"
        
        
        let device = 0
        request.setValue("\(device)", forHTTPHeaderField: "Device-Type")
        
        //            let post = NSString(format: "username=%@&password=%@", self.textMail.text!,self.textPassword.text!)
        //
        //            let data = post.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
        //
        //            let postLength = NSString(format: "%lu", (data?.count)!)
        //
        //            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        //
        //            request.httpBody = data
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                completionHandler(objects,"APIError.requestFailed")
                return
            }
            
            guard let response = response as? HTTPURLResponse
                else {
                    print ("server response error")
                    completionHandler(objects,"APIError.requestFailed")
                    return
            }
            
            print(response.statusCode)
            
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\(dataString)")
                
//                     var dataString2 =  dataString.replacingOccurrences(of: "null", with: "")
                
                
                
            }
            
            if response.statusCode == 201{
                
                DispatchQueue.main.async {
                    
                
                
                
                do{
                    
                    if let data = data {
                        
                        let decoder = JSONDecoder()
                        
                        let objects2 =  try decoder.decode(MAuthenticate<MPaySheet>.self, from: data)
                        
                        
                        
                        
                        objects = objects2
                        
                        completionHandler(objects,nil)
                        
                    }
                    else {
                        completionHandler(objects,"APIError.invalidData")
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError)
                    completionHandler(objects,"APIError.jsonParsingFailure")
                }
                }
            } else if response.statusCode == 404 {
                completionHandler(nil,"APIError.responseUnsuccessful")
            }
            
            
//                    completionHandler(objects,nil)
            
        }
        
        task.resume()
    }
    
    static func search(token:String, textSearch:String, completionHandler: @escaping(_ paySheet: MAuthenticate<MPaySheet>?, _ error:String?)->Void)  {
        
        var objects:MAuthenticate<MPaySheet>?
        
        let urlString = "http://54.184.232.181:3000/nominas/\(textSearch)"
        
        let url = NSURL(string: "http://54.184.232.181:3000/nominas/\(textSearch)" as String)
        var request = URLRequest(url: url! as URL)
        
        
        request.httpMethod = "GET"
        
        
        let device = 0
        request.setValue("\(device)", forHTTPHeaderField: "Device-Type")
        request.setValue("\(token)", forHTTPHeaderField: "access-token")
        
        //            let post = NSString(format: "username=%@&password=%@", self.textMail.text!,self.textPassword.text!)
        //
        //            let data = post.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
        //
        //            let postLength = NSString(format: "%lu", (data?.count)!)
        //
        //            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        //
        //            request.httpBody = data
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                completionHandler(objects,"APIError.requestFailed")
                return
            }
            
            guard let response = response as? HTTPURLResponse
                else {
                    print ("server response error")
                    completionHandler(objects,"APIError.requestFailed")
                    return
            }
            
            print(response.statusCode)
            
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\(dataString)")
                
//                     var dataString2 =  dataString.replacingOccurrences(of: "null", with: "")
                
                
                
            }
            
            if response.statusCode == 201{
                
                DispatchQueue.main.async {
                    
                
                
                
                do{
                    
                    if let data = data {
                        
                        let decoder = JSONDecoder()
                        
                        let objects2 =  try decoder.decode(MAuthenticate<MPaySheet>.self, from: data)
                        
                        
                        
                        
                        objects = objects2
                        
                        completionHandler(objects,nil)
                        
                    }
                    else {
                        completionHandler(objects,"APIError.invalidData")
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError)
                    completionHandler(objects,"APIError.jsonParsingFailure")
                }
                }
            } else if response.statusCode == 404 {
                completionHandler(nil,"APIError.responseUnsuccessful")
            }
            
            
//                    completionHandler(objects,nil)
            
        }
        
        task.resume()
    }
}
