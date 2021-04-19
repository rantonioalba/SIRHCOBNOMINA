//
//  LoginViewController.swift
//  SIRHCOBNOMINA
//
//  Created by Desarrollador iOS on 01/02/21.
//

import UIKit

public protocol SpinnerDelegate {
    func displaySpinner()
    func removeSpinner()
}

public protocol AlertingDelegate {
    func displayAlert(alert:UIAlertController)
}

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldUserName: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    private var viewModel = UserViewModel()
    
    var loginSuccess:((MUser?)->Void)?
    
    var appCoordinator : MainCoordinator?
    
    
    public var spinnerDelegate: SpinnerDelegate!
    var spinnerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.spinnerDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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


//MARK: Actions

extension LoginViewController {
    @IBAction func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func start() {
        self.spinnerDelegate.displaySpinner()
        viewModel.login { (user:MUser?, error:String?) in
            if let user = user {
//                self.loginSuccess!(user)
                
                
//                let appCoordinator = MainCoordinator()
//
//                appCoordinator.start()
                
                DispatchQueue.main.async {
                    self.spinnerDelegate.removeSpinner()
                    
                    self.appCoordinator = MainCoordinator(user:user)
                    self.appCoordinator?.start()
                }
                
               
                    
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Inicio de sesión no válido", message: "El usuario o la contraseña es incorrecto", preferredStyle: .alert)
                                        
                    let alertOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                        
                    alert.addAction(alertOK)
                                        
                    self.displayAlert(alert: alert)
                                        
                    self.spinnerDelegate.removeSpinner()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


//MARK: Notifications
extension LoginViewController {
    // MARK: Notifications
   @objc func handleKeyboardNotification(notification:NSNotification){
        if let userInfo = notification.userInfo {
                              
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            print(scrollView.contentInset)
            
            if isKeyboardShowing {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardFrame.size.height - 90) , right: 0)

                scrollView.contentInset = contentInsets
            } else {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)

                scrollView.contentInset = contentInsets
            }
       }
   }
}


extension LoginViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldUserName {
            textField.text = viewModel.userName
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldUserName {
            textFieldPassword.becomeFirstResponder()
        } else {
            start()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
        
        if textField == textFieldUserName {
            viewModel.updateUserName(userName: newString)
        }
        
        if textField == textFieldPassword {
            viewModel.updatePassword(password: newString)
        }
        
        
        return true
    }
}

extension LoginViewController:SpinnerDelegate {
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

extension LoginViewController:AlertingDelegate {
    func displayAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

