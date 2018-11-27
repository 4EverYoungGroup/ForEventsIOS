//
//  RegisterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

let activityIndicator = UIActivityIndicatorView(style: .gray)

class RegisterViewController: UIViewController {
    
    var originCall: String?
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var psw1TextField: UITextField!
    @IBOutlet weak var psw2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    
    var gender: String = "M"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white

        //Gesture to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //If viewcontroller is call from edit mode recover de user data
        if self.originCall == "update" {
            self.registerButton.setTitle("Guardar", for: .normal)
            ExecuteInteractorImpl().execute {
                self.getUserData()
            }
        } else {
            self.registerButton.setTitle("Registro", for: .normal)
        }
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        if self.originCall == "update" {
            if self.validateRegister() {
                //Configure activity indicator
                view.addSubview(activityIndicator)
                activityIndicator.frame = view.bounds
                activityIndicator.startAnimating()
                
                ExecuteInteractorImpl().execute {
                    updateUser()
                }
            }
        } else {
            if self.validateRegister() {
                //Configure activity indicator
                view.addSubview(activityIndicator)
                activityIndicator.frame = view.bounds
                activityIndicator.startAnimating()
                
                ExecuteInteractorImpl().execute {
                    registerUser()
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateRegister() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.regTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if self.originCall != "update" {
            //passwords is valid, must include uppercase, lowercase and digits and 6 long min
            if !(psw1TextField.text?.isValidPassword())! {
                let alert = Alerts().alert(title: Constants.regTitle, message: "El formato de la password es erróneo. Debe contener al menos 6 caracteres, una mayúscula y un dígito.")
                self.psw1TextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
                return false
            }
            //passwords are the same
            if psw1TextField.text != psw2TextField.text {
                let alert = Alerts().alert(title: Constants.regTitle, message: "Las password son distintas.")
                self.psw1TextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
                return false
            }
        } else {
            if (psw1TextField.text?.isEmpty)! && (psw2TextField.text?.isEmpty)! {
                return true
            } else {
                //passwords is valid, must include uppercase, lowercase and digits and 6 long min
                if !(psw1TextField.text?.isValidPassword())! {
                    let alert = Alerts().alert(title: Constants.regTitle, message: "El formato de la password es erróneo. Debe contener al menos 6 caracteres, una mayúscula y un dígito.")
                    self.psw1TextField.becomeFirstResponder()
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
                //passwords are the same
                if psw1TextField.text != psw2TextField.text {
                    let alert = Alerts().alert(title: Constants.regTitle, message: "Las password son distintas.")
                    self.psw1TextField.becomeFirstResponder()
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        //name is valid
        if (nameTextField.text?.isEmptyOrWhitespace())! {
            let alert = Alerts().alert(title: Constants.regTitle, message: "Debe introducir un nombre.")
            self.nameTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func registerUser() {
        
        let user = User(email: userTextField.text!, password: psw1TextField.text!, firstname: nameTextField.text!, profile: "User", lastname: lastnameTextField.text, country: countryTextField.text, province: provinceTextField.text, zipCode: zipCodeTextField.text, city: nil, alias: aliasTextField.text, gender: gender, birthdayDate: nil)
        
        let registerUserInteractor: RegisterUserInteractor = RegisterUserInteractorNSURLSessionImpl()
        
        registerUserInteractor.execute(user: user) { (responseApi: ResponseApi?) in
            if responseApi == nil {
                UserDefaults.standard.set(true, forKey: Constants.username)
                UserDefaults.standard.setValue(self.userTextField.text, forKey: Constants.username)
                self.tabBarController?.selectedIndex = 0
            } else {
                guard let message = responseApi!.errors![0].message else { return }
                let alert = Alerts().alert(title: Constants.regTitle, message: message)
                self.nameTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateUser() {
        
        let user = User(email: userTextField.text!, password: psw1TextField.text, firstname: nameTextField.text!, profile: "User", lastname: lastnameTextField.text, country: countryTextField.text, province: provinceTextField.text, zipCode: zipCodeTextField.text, city: nil, alias: aliasTextField.text, gender: gender, birthdayDate: nil)
        
        let upadateUserInteractor: UpdateUserInteractor = UpdateUserInteravarrNSURLSessionImpl()
        
        upadateUserInteractor.execute(user: user) { (user: User?) in
            if user != nil {
                let alert = Alerts().alert(title: Constants.regTitle, message: "Usuario actualizado correctamente.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func genderSegmentPress(_ sender: UISegmentedControl) {
        switch genderSegmented.selectedSegmentIndex {
        case 0:
            gender = "M"
        case 1:
            gender = "F"
        case 2:
            gender = "O"
        default:
            break
        }
    }
    
    func getUserData() {
        if let userID = UserDefaults.standard.value(forKey: Constants.userID) {
            
            let getUserInteractor: GetUserInteractor = GetUserInteractorNSURLSessionImpl()
            
            getUserInteractor.execute(userID: userID as! String) { (user: User?) in
                if user != nil {
                    self.userTextField.text = user?.email
                    self.userTextField.isUserInteractionEnabled = false
                    self.nameTextField.text = user?.firstname
                    self.lastnameTextField.text = user?.lastname
                    self.cityTextField.text = user?.city
                    self.provinceTextField.text = user?.province
                    self.countryTextField.text = user?.country
                    self.zipCodeTextField.text = user?.zipCode
                    self.aliasTextField.text = user?.alias
                    switch user?.gender {
                    case "M":
                        self.genderSegmented.selectedSegmentIndex = 0
                    case "F":
                        self.genderSegmented.selectedSegmentIndex = 1
                    case "O":
                        self.genderSegmented.selectedSegmentIndex = 2
                    default:
                        self.genderSegmented.selectedSegmentIndex = 0
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewController(animated: true)
    }
}
