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
    
    public var spinnerDelegate: SpinnerDelegate!
    var spinnerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.spinnerDelegate = self
        
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
        
        if let search = searchBar.text {
            
            self.spinnerDelegate.displaySpinner()
            self.viewModel.find(texrSearch: search) { (response:Bool?) in
                if response == true {
                    DispatchQueue.main.async {
                        self.spinnerDelegate.removeSpinner()
                        self.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.spinnerDelegate.removeSpinner()
                    }
                }
            }
        }
        
        
//        let index = viewModel.indexOf(employeeNumber: searchBar.text ?? "")
//
//        if index != -1 {
//            let indexPath = IndexPath(item: index, section: 0)
//
//            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
//        }
//
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

extension PaySheetViewController:SpinnerDelegate {
    func displaySpinner() {
        self.spinnerView = self.view.viewWithTag(2000)
        
        if self.spinnerView == nil {
            if let window = UIApplication.shared.keyWindow {
                spinnerView = UIView.init(frame: window.frame)
                spinnerView!.tag = 2000
                spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
                
                let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
                
                
                indicatorView.startAnimating()
                
                indicatorView.center = (spinnerView?.center)!
                
                DispatchQueue.main.async {
                    self.spinnerView?.addSubview(indicatorView)
                    
                    self.view.addSubview(self.spinnerView!)
                }
            }
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
        }
    }
}

extension PaySheetViewController:AlertingDelegate {
    func displayAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
