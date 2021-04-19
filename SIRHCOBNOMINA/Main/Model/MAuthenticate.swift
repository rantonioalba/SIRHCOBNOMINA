//
//  MAuthenticate.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 13/02/21.
//

import Foundation

struct MAuthenticate<T>:Codable where T:Codable {
    var error:String?
    var body:[T]
    
}
