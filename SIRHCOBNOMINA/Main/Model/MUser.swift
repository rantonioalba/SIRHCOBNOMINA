//
//  User.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 08/02/21.
//

import Foundation

struct MUser:Codable {
    var profile:String?
    var name:String?
    var numberEmp:String?
    var password:String?
    var passEnc:String?
    var token:String?
    
    enum CodingKeys: String, CodingKey {
        case profile = "u_perfil"
        case name = "u_name"
        case numberEmp = "u_numemp"
        case passEnc = "u_passenc"
        case token
    }
}
