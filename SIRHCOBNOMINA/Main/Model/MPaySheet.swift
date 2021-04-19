//
//  MPaySheet.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 16/02/21.
//

import Foundation

extension String {
    func padLeft(totalWidth:Int, with:String) -> String {
        let toPad = totalWidth - self.count
                if toPad < 1 { return self }
                return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
}

extension Encodable {
    var dictionary:[String:Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {$0 as? [String:Any] }
    }
    
    func getValue(desc:String) -> Any? {
        
        print(dictionary)
        
        let value = dictionary?[desc]
        
        return value
    }
}

struct MPaySheet:Codable {
    var quincenapago:Int?
    var numemp:String?
    var nombreempleado:String?
    var fchingcobaev:String?
    var antiguedad:String?
    var clavecategoria:String?
    var desccategoria:String?
    var claveplantel:String?
    var descplantel:String?
    var clavect:String?
    var nombrect:String?
    var idqnavigini:Int?
    var idqnavigfin:Int?
    var qnainicio:String?
    var qnafin:String?
    var idesquemapago:Int?
    var esquemapago:String?
    var permensualneto:String?
    var dedmensualneto:String?
    var totmensualneto:String?
    var compensacion:String?
    var percquinbruto:String?
    var deduquinbruto:String?
    var totquinbruto:String?
    var totmenbruto:String?
    var idsindicato:Int?
    var siglassindicato:String?
    var idtipoemp:Int?
    var tipoempleado:String?
    var idempfuncion:Int?
    var empfuncion:String?
    var idfuncionpri:Int?
    var funcionpri:String?
    var idfuncionsec:Int?
    var funcionsec:String?
    var clavemotgralbaja:Int?
    var desmotgralbaja:String?
    var interinopuro:Int?
    var orden:Int?
    var verificado:Int?
    var observaciones:String?
    var compensacionpa:String?
    var rfc:String?
    var totmensualnetopluscomp:String?
    var percmenbruto:String?
    var dedmenbruto:String?
    var totalmensualbrutopluscomp:String?
    var categoria:String?
    
    
    
//    var totmensualnetopluscomp:String {
//        set {
//
//        }
//
//        get{
//            let formatter = NumberFormatter()
//
//            formatter.numberStyle = .currency
//
//            formatter.numberStyle = .currency
//
//            formatter.locale = Locale(identifier: "es_MX")
//
//            guard let number = formatter.number(from: totmensualneto ?? "")  else {
//                return ""
//            }
//
//            let mensualneto = number.doubleValue
//
//
//
//            guard let number2 = formatter.number(from: compensacion ?? "") else {
//                return ""
//            }
//
//
//            let comp = number2.doubleValue
//
//            let total = mensualneto + comp
//
//
////            formatter.numberStyle = .decimal
////
////            formatter.maximumFractionDigits = 2
//
//            guard let  totalString  = formatter.string(from: NSNumber(value: total)) else { return "" }
//
//
//
//            return totalString
//        }
//    }
    
    
    enum CodingKeys: String, CodingKey {
        case quincenapago
        case numemp
        case nombreempleado
        case fchingcobaev
        case antiguedad
        case clavecategoria
        case desccategoria
        case claveplantel
        case descplantel
        case clavect
        case nombrect
        case idqnavigini
        case idqnavigfin
        case qnainicio
        case qnafin
        case idesquemapago
        case esquemapago
        case permensualneto
        case dedmensualneto
        case totmensualneto
        case compensacion
        case percquinbruto
        case deduquinbruto
        case totquinbruto
        case totmenbruto
        case idsindicato
        case siglassindicato
        case idtipoemp
        case tipoempleado
        case idempfuncion
        case empfuncion
        case idfuncionpri
        case funcionpri
        case idfuncionsec
        case funcionsec
        case clavemotgralbaja
        case desmotgralbaja
        case interinopuro
        case orden
        case verificado
        case observaciones
        case compensacionpa
        case rfc
        case totmensualnetopluscomp
        case percmenbruto
        case dedmenbruto
        case totalmensualbrutopluscomp
        case categoria
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.quincenapago = try container.decode(Int.self, forKey: .quincenapago)
        self.numemp = try container.decode(String.self, forKey: .numemp)
        self.nombreempleado = try container.decode(String.self, forKey: .nombreempleado)
        self.fchingcobaev = try container.decode(String.self, forKey: .fchingcobaev)
        self.antiguedad = try container.decode(String.self, forKey: .antiguedad)
        self.clavecategoria = try container.decode(String.self, forKey: .clavecategoria)
        self.desccategoria = try container.decode(String.self, forKey: .desccategoria)
        self.claveplantel = try container.decode(String.self, forKey: .claveplantel)
        self.descplantel = try container.decode(String.self, forKey: .descplantel)
        self.clavect = try container.decode(String.self, forKey: .clavect)
        self.nombrect = try container.decode(String.self, forKey: .nombrect)
        self.idqnavigini = try container.decode(Int.self, forKey: .idqnavigini)
        self.idqnavigfin = try container.decode(Int.self, forKey: .idqnavigfin)
        self.qnainicio = try container.decode(String.self, forKey: .qnainicio)
        self.qnafin = try container.decode(String.self, forKey: .qnafin)
        self.idesquemapago = try container.decode(Int.self, forKey: .idesquemapago)
        self.esquemapago = try container.decode(String.self, forKey: .esquemapago)
        self.permensualneto = try container.decode(String.self, forKey: .permensualneto)
        self.dedmensualneto = try container.decode(String.self, forKey: .dedmensualneto)
        self.totmensualneto = try container.decode(String.self, forKey: .totmensualneto)
        self.compensacion = try container.decode(String.self, forKey: .compensacion)
        self.percquinbruto = try container.decode(String.self, forKey: .percquinbruto)
        self.deduquinbruto = try container.decode(String.self, forKey: .deduquinbruto)
        self.totquinbruto = try container.decode(String.self, forKey: .totquinbruto)
        self.totmenbruto = try container.decode(String.self, forKey: .totmenbruto)
        self.idsindicato = try container.decode(Int.self, forKey: .idsindicato)
        self.siglassindicato = try container.decode(String.self, forKey: .siglassindicato)
        self.idtipoemp = try container.decode(Int.self, forKey: .idtipoemp)
        self.tipoempleado = try container.decode(String.self, forKey: .tipoempleado)
        self.idempfuncion = try container.decode(Int.self, forKey: .idempfuncion)
        self.empfuncion = try container.decode(String.self, forKey: .empfuncion)
        self.idfuncionpri = try container.decode(Int.self, forKey: .idfuncionpri)
        self.funcionpri = try container.decode(String.self, forKey: .funcionpri)
        self.idfuncionsec = try container.decode(Int.self, forKey: .idfuncionsec)
        self.funcionsec = try container.decode(String.self, forKey: .funcionsec)
        self.clavemotgralbaja = try container.decode(Int.self, forKey: .clavemotgralbaja)
        self.desmotgralbaja = try container.decode(String.self, forKey: .desmotgralbaja)
        self.interinopuro = try container.decode(Int.self, forKey: .interinopuro)
        self.orden = try container.decode(Int.self, forKey: .orden)
        self.verificado = try container.decode(Int.self, forKey: .verificado)
        self.observaciones = try container.decode(String.self, forKey: .observaciones)
        self.compensacionpa = try container.decode(String.self, forKey: .compensacionpa)
        self.rfc = try container.decode(String.self, forKey: .rfc)
        self.totmensualnetopluscomp = try container.decodeIfPresent(String.self, forKey: .totmensualnetopluscomp)
        self.percmenbruto = try container.decodeIfPresent(String.self, forKey: .percmenbruto)
        self.dedmenbruto = try container.decodeIfPresent(String.self, forKey: .dedmenbruto)
        self.totalmensualbrutopluscomp = try container.decodeIfPresent(String.self, forKey: .totalmensualbrutopluscomp)
        
        
        
        
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        
        formatter.numberStyle = .currency
        
        formatter.locale = Locale(identifier: "es_MX")
        
        guard let number = formatter.number(from: totmensualneto ?? "")  else {
            return
        }
        
        let mensualneto = number.doubleValue
        
        guard let number2 = formatter.number(from: compensacion ?? "") else {
            return
        }
        
        let comp = number2.doubleValue
        
        let total = mensualneto + comp
        
        
        guard let  totalString  = formatter.string(from: NSNumber(value: total)) else { return  }
        
                
        self.totmensualnetopluscomp = totalString
        
        
        
        guard let number3 = formatter.number(from: percquinbruto ?? "") else {
            return
        }
        
        let percepcionquincenalbruto = number3.doubleValue * 2
        
        
        guard let percepcionquincenalbrutoString = formatter.string(from: NSNumber(value: percepcionquincenalbruto)) else { return }
        
        
        self.percmenbruto = percepcionquincenalbrutoString
        
        
        guard let number4 = formatter.number(from: deduquinbruto  ?? "") else {
            return
        }
        
        let deduccionquincenalbruto = number4.doubleValue * 2
        
        guard let deduccionquincenalbrutoString = formatter.string(from: NSNumber(value: deduccionquincenalbruto)) else { return }
        
        self.dedmenbruto = deduccionquincenalbrutoString
        
        guard let number5 = formatter.number(from: totmenbruto ?? "") else {
            return
        }
        
        
        let totalmenbruto = number5.doubleValue
        
        
        
        guard let number6 = formatter.number(from: compensacion ?? "") else {
            return
        }
        
        let totalcompensacion = number6.doubleValue
        
        guard let number7 = formatter.number(from: compensacionpa ?? "") else {
            return
        }
        
        let totalcompensacionpa = number7.doubleValue
        
        
        let totalmenbrutopluscomp = totalmenbruto + totalcompensacion + totalcompensacionpa
        
        guard let totalmenbrutopluscompstring = formatter.string(from: NSNumber(value: totalmenbrutopluscomp)) else { return }
        
        self.totalmensualbrutopluscomp = totalmenbrutopluscompstring
        
        self.categoria = "\(self.clavecategoria ?? "") - \(self.desccategoria ?? "")"
        
        
    }
    
//    var employeeNumber:String?
//    var employeeName:String?
//    var campusKey:String?
//    var campusName:String?
//    var categoryKey:String?
//    var categoryName:String?
//    var admissionDate:String?
//    var syndicateId:Int?
//    var acronymSyndicate:String?
//
//
//
//
//    enum CodingKeys: String, CodingKey {
//        case employeeNumber = "numemp"
//        case employeeName = "nombreempleado"
//        case campusKey = "claveplantel"
//        case campusName = "descplantel"
//        case categoryKey = "clavecategoria"
//        case categoryName = "desccategoria"
//        case admissionDate = "fchingcobaev"
//        case syndicateId = "idsindicato"
//        case acronymSyndicate = "siglassindicato"
//    }
}
