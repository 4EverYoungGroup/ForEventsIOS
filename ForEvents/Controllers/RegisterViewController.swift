//
//  RegisterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var psw1TextField: UITextField!
    @IBOutlet weak var psw2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gesture to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        if self.validateRegister() {
            UserDefaults.standard.set(true, forKey: Constants.username)
            UserDefaults.standard.setValue(userTextField.text, forKey: Constants.username)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateRegister() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //passwords is valid, must include uppercase, lowercase and digits and 6 long min
        if !(psw1TextField.text?.isValidPassword())! {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "El formato de la password es erróneo. Debe contener al menos 6 caracteres, una mayúscula y un dígito.")
            self.psw1TextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //passwords are the same
        if psw1TextField.text != psw2TextField.text {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "Las password son distintas.")
            self.psw1TextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //name is valid
        if (nameTextField.text?.isEmptyOrWhitespace())! {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "Debe introducir un nombre.")
            self.nameTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

}
