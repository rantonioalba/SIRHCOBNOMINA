//
//  PaySheetViewModel.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 16/02/21.
//

import Foundation



class PaySheetViewModel : NSObject {
    	
    private var paySheet:MAuthenticate<MPaySheet>?
    
    fileprivate var paySheetSelected:MPaySheet!
    
    var user:MUser!
    
    var coordinator:PaySheetCoordinator?
    
    
    func numberOfItemsInSection(section:Int) -> Int {
        return paySheet?.body.count ?? 0
    }
    
    func employeeNameAtIndexPath(indexPath:IndexPath) -> String {
        return "\(paySheet?.body[indexPath.row].numemp ?? "") -  \(paySheet?.body[indexPath.row].nombreempleado ?? "")"
    }
    
    func employeeCampusAtIndexPath(indexPath:IndexPath) -> String {
        return "\(paySheet?.body[indexPath.row].claveplantel?.padLeft(totalWidth: 3, with: "0") ?? "") - \(paySheet?.body[indexPath.row].descplantel ?? "")"
    }
    
    func employeeCategoryAtIndexPath(indexPath:IndexPath) -> String {
        return "\(paySheet?.body[indexPath.row].clavecategoria ?? "") - \(paySheet?.body[indexPath.row].desccategoria ?? "")"
    }
    
    func employeeDataOfAdmission(indexPath:IndexPath) -> String {
        return "Fecha de ingreso | \(paySheet?.body[indexPath.row].fchingcobaev ?? "")"
    }
    
    func employeeSyndicate(indexPath:IndexPath) -> String {
        return "Sindicato | \(paySheet?.body[indexPath.row].siglassindicato ?? "")"
    }
    
    func employeeWorkCenter(indexPath:IndexPath) -> String {
        return "Centro de trabajo | \(paySheet?.body[indexPath.row].nombrect ?? "")"
    }
    
    func urlEmployeeJPG(indexPath:IndexPath) -> String {
        return "http://sigaa.cobaev.edu.mx/festival/fotos/personal/\(self.paySheet?.body[indexPath.row].numemp ?? "")"
    }
    
    func employeeFunctionSecond(indexPath:IndexPath) -> String {
        return "Función secundaria | \(paySheet?.body[indexPath.row].funcionsec ?? "")"
    }
    
    func employeeFortnightStart(indexPath:IndexPath) -> String {
        return "Quin inicio | \(paySheet?.body[indexPath.row].qnainicio ?? "")"
    }
    
    func employeeFortnightEnd(indexPath:IndexPath) -> String {
        return "Quin fin | \(paySheet?.body[indexPath.row].qnafin ?? "")"
    }
    
    func cellSelectedAtIndexPath(indexPath:IndexPath)  {
        paySheetSelected = paySheet?.body[indexPath.row]
        
        coordinator?.startPaySheetDetail(paySheet:paySheetSelected)
    }
    
    func isEmployeeDischargd(indexPath:IndexPath) -> Bool {
        let obs = self.paySheet?.body[indexPath.row].observaciones
            if obs == "Baja" {
                return true
            } else {
                return false
            }
    }
    
    func indexOf(employeeNumber:String) -> Int {
        if let index = paySheet?.body.firstIndex(where: {($0.numemp?.contains(employeeNumber))!}) {
            return index
        }
        return -1
    }
    
    
    func fetch(completionHandler:@escaping(_ response:Bool?)->Void)  {
        PaySheetService.getPaySheet(token: user.token!) { (paySheet:MAuthenticate<MPaySheet>?, error:String?) in
            if let paySheet = paySheet {
                print(paySheet)
                self.paySheet = paySheet
                
                print("Dictionary")
                print(paySheet.dictionary)
                
                
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    
    func fetch(token:String, completionHandler:@escaping(_ response:Bool?)->Void)  {
        
        PaySheetService.getPaySheet(token: token) { (paySheet:MAuthenticate<MPaySheet>?, error:String?) in
            
            if let paySheet = paySheet {
                print(paySheet)
                self.paySheet = paySheet
                
                print("Dictionary")
                print(paySheet.dictionary)
                
                
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
        }
    }
    
    
    
}


//For PaySheetDetailViewController
extension PaySheetViewModel {
    
}
