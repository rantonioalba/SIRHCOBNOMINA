//
//  PaySheetViewController.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 16/02/21.
//

import UIKit

class PaySheetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PaySheetViewModel!
    
    
    let searchBar:UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "Número de empleado"
        
        search.keyboardType = .numberPad
        
        return search
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for family in UIFont.familyNames {
            print("========family:\(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("     -----------font name:\(fontName)")
            }
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 55/255.0, green: 180/255.0, blue: 89/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.tintColor  = UIColor.white
        self.navigationItem.titleView = searchBar
        
        searchBar.delegate =  self
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            
            textField.backgroundColor = UIColor(red: 55/255.0, green: 180/255.0, blue: 89/255.0, alpha: 1.0)
            textField.textColor = UIColor.white
            
            textField.attributedPlaceholder = NSAttributedString(string: "Número de empleado", attributes: [NSAttributedString.Key.font: UIFont(name: "Araboto-Normal", size: 14.0)!, NSAttributedString.Key.foregroundColor:UIColor.white])
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
            
            if let rightView = textField.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                rightView.tintColor = UIColor.white
            }
        }
        
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.barStyle = .black
        toolbarDone.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let barBtnDone = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.done, target: self, action: #selector(tapButtonAcept(_:)))
        
        toolbarDone.items = [space, barBtnDone] // You can even add cancel button too
        
        searchBar.inputAccessoryView = toolbarDone
        
        tableView.register(UINib.init(nibName: "PaySheetViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        
        self.viewModel.fetch { (response:Bool?) in
            if response == true {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if !LoginService.isAuthenticated {
//            presentLoginViewController()
//        }
    }
    
    
    @objc func tapButtonAcept(_ sender:UIBarButtonItem)  {
        self.searchBar.resignFirstResponder()
        
        
        let index = viewModel.indexOf(employeeNumber: searchBar.text ?? "")
        
        if index != -1 {
            let indexPath = IndexPath(item: index, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
        
        searchBar.text = ""
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PaySheetViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaySheetViewCell
        
        cell.selectionStyle = .none
        
        cell.configureCellAtIndexPath(indexPath: indexPath, viewModel: viewModel)
        
        return cell
    }
}

extension PaySheetViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellSelectedAtIndexPath(indexPath:indexPath)
    }
}


extension PaySheetViewController : UISearchBarDelegate {
    
}

private extension PaySheetViewController {
    func presentLoginViewController(completionHandler:(() -> Void)? = nil) {
        let loginController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        loginController.loginSuccess = { [weak self] user in
            
            guard self != nil else {
                return
            }
                    
            if user == nil {
                return
            }
            
            self?.viewModel.fetch(token: (user?.token)!, completionHandler: { (response:Bool?) in
                
                if response == true {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        loginController.modalPresentationStyle = .fullScreen
        self.present(loginController, animated: true, completion: completionHandler)
    }
}
