//
//  PaySheetDetailViewModel.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 24/02/21.
//

import Foundation

class PaySheetDetailViewModel: NSObject {
    
    var paySheet:MPaySheet!
    
    var coordinator:PaySheetDetailCoordinator?
    
    
//    private let dict = [MPaySheetDetail(fieldName: "desccategoria", desc: "Categoría"), MPaySheetDetail(fieldName: "fchingcobaev", desc: "Fecha de ingreso"),MPaySheetDetail(fieldName: "antiguedad", desc: "Antiguedad"),MPaySheetDetail(fieldName: "descplantel", desc: "Adscripción")]
    
    
    var title:String {
        get {
            
            if let numemp = paySheet.numemp, let name = paySheet.nombreempleado {
                return numemp + "-" + name
            }
            
            return paySheet.nombreempleado ?? ""
    
        }
    }
    
    private let dict = ["0 Datos Generales":[MPaySheetDetail(fieldName: "categoria", desc: "Categoría:"),MPaySheetDetail(fieldName: "fchingcobaev", desc: "Fecha de ingreso:"),MPaySheetDetail(fieldName: "antiguedad", desc: "Antiguedad:"),MPaySheetDetail(fieldName: "rfc", desc: "RFC:"),MPaySheetDetail(fieldName: "nombrect", desc: "Adscripción:")], "1 Datos de Plaza":[MPaySheetDetail(fieldName: "esquemapago", desc: "Esquema de pago:"), MPaySheetDetail(fieldName: "qnainicio", desc: "Quincena inicio:"),
    MPaySheetDetail(fieldName: "qnafin", desc: "Quincena fin:"),MPaySheetDetail(fieldName: "desmotgralbaja", desc: "Motivo de baja:"),
    MPaySheetDetail(fieldName: "tipoempleado", desc: "Tipo de contrato:")],"2 Ingresos Ordinarios Mensuales":[MPaySheetDetail(fieldName: "permensualneto", desc: "Percepciones ordinarias"),MPaySheetDetail(fieldName: "dedmensualneto", desc: "Deducciones ordinarias:"),MPaySheetDetail(fieldName: "totmensualneto", desc: "Mensual neto ordinario:"),MPaySheetDetail(fieldName: "compensacion", desc: "Compensación:"),MPaySheetDetail(fieldName: "totmensualnetopluscomp", desc: "Mensual ordinario neto + Compensación:",isBold: true)],"3 Ingresos Ordinarios y Extraordinarios Generales":[MPaySheetDetail(fieldName: "percmenbruto", desc: "Percepciones ord y, extra:"),MPaySheetDetail(fieldName: "dedmenbruto", desc: "Deducciones ord y extra:"),MPaySheetDetail(fieldName: "totmenbruto", desc: "Mensual neto para pago:",isBold: true), MPaySheetDetail(fieldName: "compensacion", desc: "Compensación:"), MPaySheetDetail(fieldName: "compensacionpa", desc: "Pensión alimenticia:"), MPaySheetDetail(fieldName: "totalmensualbrutopluscomp", desc: "Sueldo mensual neto + Compensación en nómina",isBold: true),  MPaySheetDetail(fieldName: "totquinbruto", desc: "Sueldo quincenal:",isBold: true)],"4 Otros detalles":[MPaySheetDetail(fieldName:"siglassindicato",desc:"Sindicato:"),MPaySheetDetail(fieldName:"empfuncion", desc:"Función general:"),MPaySheetDetail(fieldName: "funcionpri", desc: "Función primaria:"),MPaySheetDetail(fieldName: "funcionsec", desc: "Función secundaria:")]]
    
    func urlEmployeeJPG() -> String {
        return "http://sigaa.cobaev.edu.mx/festival/fotos/personal/\(self.paySheet?.numemp ?? "")"
    }
    
    func numberOfSections() -> Int {
        print(dict.count)
        return dict.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        let sortedKeys = Array(dict.keys).sorted { (cad1, cad2) -> Bool in
            return cad1 < cad2
        }
        
//        let values = self.dictionary[sortedKeys[section]]?.filter({ (extraProd) -> Bool in
//            return extraProd.requiresLegend == false
//        })
        
        let values = self.dict[sortedKeys[section]]
        
        print(values!.count)
        
        return values!.count
    }
    
    
    func titleForHeaderInSection(section:Int) -> String {
        let sortedKeys = Array(dict.keys).sorted { (cad1, cad2) -> Bool in
            return cad1 < cad2
        }
        
        let title = sortedKeys[section]
        
        
        
//        return sortedKeys[section]
        
        let indexStart  =  title.index(after: title.startIndex )// you can use any index in place of startIndex
        let strIndexStart   = String (title[indexStart...])//23456789
        
        return strIndexStart
    }
    
    
    func descAtIndexPath(indexPath:IndexPath) -> String {
        let sortedKeys = Array(dict.keys).sorted { (cad1, cad2) -> Bool in
            return cad1 < cad2
        }
        
        
        let values = self.dict[sortedKeys[indexPath.section]]
        
        print(values?.count)
        
        
        return (values?[indexPath.row].desc)!
        
        
    
    }
    
    func valueAtIndexPath(indexPath:IndexPath) -> String {
//        return paySheet.getValue(desc: dict[indexPath.row].desc!)
        
//        let value = paySheet.getValue(desc: dict[indexPath.row].fieldName!)
        
         
        
        
        let sortedKeys = Array(dict.keys).sorted { (cad1, cad2) -> Bool in
            return cad1 < cad2
        }
        
        
        let values = self.dict[sortedKeys[indexPath.section]]
        
        
        let value = paySheet.getValue(desc: (values?[indexPath.row].fieldName)!)
        
        
        let sueldonetopluscomp = paySheet.totmensualnetopluscomp
        
        print(sueldonetopluscomp)
        
        if let stringValue = value as? String {
            return stringValue
        }
        
//        let anyMirror = Mirror(reflecting: value!)
//
//        if anyMirror.subjectType ==  {
//            return value as! String
//        }
        
        return "Hi"
        
        
    }
    
    func isEmployeeDischargd() -> Bool {
        let obs = self.paySheet.observaciones
            if obs == "Baja" {
                return true
            } else {
                return false
            }
    
    }
    
    func descriptionEmployeeDischarged() -> String {
        guard let desc = self.paySheet.desmotgralbaja else {
            return ""
        }
        
        return desc
    }
    
    
    func isBoldAtIndexPath(indexPath:IndexPath) -> Bool {
        let sortedKeys = Array(dict.keys).sorted { (cad1, cad2) -> Bool in
            return cad1 < cad2
        }
        
        let values = self.dict[sortedKeys[indexPath.section]]
        
        print(values?.count)
        
        
        return (values?[indexPath.row].isBold)!
    }
    
    func viewDidDissapear() {
        coordinator?.didFinishPaySheetDetail()
    }
    
}
