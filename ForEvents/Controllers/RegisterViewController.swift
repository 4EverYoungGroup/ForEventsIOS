//
//  RegisterViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import SearchTextField

let activityIndicator = UIActivityIndicatorView(style: .gray)

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var originCall: String?
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var psw1TextField: UITextField!
    @IBOutlet weak var psw2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var cityTextField: SearchTextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    
    var gender: String = "M"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.delegate = self
        
        //Configure search text field
        configureSearchTextField(textField: cityTextField)
        
        self.navigationController?.navigationBar.tintColor = .white

        //Gesture to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //If viewcontroller is call from edit mode recover de user data
        if self.originCall == "update" {
            self.registerButton.setTitle("Guardar", for: .normal)
            self.configureDeleteButton()
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
        //Recover favorite city province country and zipcode selected
        if !self.validateCity() {
            let alert = Alerts().alert(title: Constants.findTitle, message: "Debe de seleccionar una localidad de la lista.")
            self.cityTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func registerUser() {
        
        let user = User(email: userTextField.text!, password: psw1TextField.text!, firstname: nameTextField.text!, profile: "User", lastname: lastnameTextField.text, country: countryTextField.text, province: provinceTextField.text, zipCode: zipCodeTextField.text, city: Global.citySelectedId, alias: aliasTextField.text, gender: gender, birthdayDate: nil)
        
        let registerUserInteractor: RegisterUserInteractor = RegisterUserInteractorNSURLSessionImpl()
        
        registerUserInteractor.execute(user: user) { (responseApi: ResponseApi?) in
            if responseApi == nil {
                UserDefaults.standard.set(true, forKey: Constants.username)
                UserDefaults.standard.setValue(self.userTextField.text, forKey: Constants.username)
                self.tabBarController?.selectedIndex = 0
            } else {
                if let message = responseApi?.message {
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let message = responseApi!.errors![0].message else { return }
                    let alert = Alerts().alert(title: Constants.regTitle, message: message)
                    self.present(alert, animated: true, completion: nil)
                }
                self.nameTextField.becomeFirstResponder()
            }
        }
    }
    
    func updateUser() {
        
        let user = User(email: userTextField.text!, password: psw1TextField.text, firstname: nameTextField.text!, profile: "User", lastname: lastnameTextField.text, country: countryTextField.text, province: provinceTextField.text, zipCode: zipCodeTextField.text, city: Global.citySelectedId, alias: aliasTextField.text, gender: gender, birthdayDate: nil)
        
        let upadateUserInteractor: UpdateUserInteractor = UpdateUserInteractorNSURLSessionImpl()
        
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
    
    func configureDeleteButton() {
        var editButton: UIBarButtonItem = UIBarButtonItem()
        let image = UIImage(named: "deleteUser")?.withRenderingMode(.alwaysOriginal)
        editButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteUserTapped))
        editButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func deleteUserTapped() {
        //Delete user - Alert
        let deleteUserAlertController = UIAlertController (title: "Atención, ha solicitado borrar su usuario", message: "Esta acción borrará su usuario y todos sus datos de la app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Borrar", style: .destructive) { (_) -> Void in
            //Delete user
            self.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        deleteUserAlertController .addAction(settingsAction)
        deleteUserAlertController .addAction(cancelAction)
        self.present(deleteUserAlertController, animated: true, completion: nil)
    }
    
    func deleteUser() {
        let deleteUserInteractor: DeleteUserInteractor = DeleteUserInteractorNSURLSessionImpl()
        
        deleteUserInteractor.execute { 
            let loginTabBarController = createLoginTabBar()
            //Show login in tabbar
            loginTabBarController.selectedIndex = 0
            //Configure tabbar without background and shadow
            loginTabBarController.tabBar.backgroundImage = UIImage()
            loginTabBarController.tabBar.shadowImage = UIImage()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginTabBarController
        }
    }
    
    func validateCity() -> Bool {
        if self.cityTextField.text != "" {
            let cityTextSelected = self.cityTextField.text?.components(separatedBy: "/")
            let citySelected = Global.citiesSelected?.filter({$0.city == cityTextSelected![0]})
            if (citySelected?.count)! == 1 {
                let city: City = citySelected![0]
                Global.citySelectedPosition = []
                self.provinceTextField.text = city.province
                self.countryTextField.text = city.country
                self.zipCodeTextField.text = city.zipCode
                Global.citySelectedId = city.id
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == cityTextField {
            //Recover favorite city province country and zipcode selected
            if !self.validateCity() {
                let alert = Alerts().alert(title: Constants.findTitle, message: "Debe de seleccionar una localidad de la lista o no poner nada.")
                self.cityTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cityTextField {
            cityTextField.text = ""
            provinceTextField.text = ""
            countryTextField.text = ""
            zipCodeTextField.text = ""
        }
    }
}
