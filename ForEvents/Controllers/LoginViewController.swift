//
//  LoginViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var tokenItems: [KeychainTokenItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gesture to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Put username in userTextField
        if let username = UserDefaults.standard.value(forKey: Constants.username) {
            self.userTextField.text = username as? String
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPress(_ sender: UIButton) {
        if self.validateLogin() {
            //Configure activity indicator
            view.addSubview(activityIndicator)
            activityIndicator.frame = view.bounds
            activityIndicator.startAnimating()
            
            ExecuteInteractorImpl().execute {
                loginUser()
            }
        }
    }
    
    @IBAction func recoverButtonPress(_ sender: UIButton) {
        if self.validateRecover() {
            //Configure activity indicator
            view.addSubview(activityIndicator)
            activityIndicator.frame = view.bounds
            activityIndicator.startAnimating()
            
            ExecuteInteractorImpl().execute {
                recoverUser()
            }
        }
    }
    
    func validateLogin() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //passwords is valid, must include uppercase, lowercase and digits and 6 long min
        if (passwordTextField.text?.isEmpty)! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "La password es obligatoria.")
            self.passwordTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRecover() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.loginTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func loginUser() {
        let userLogin = UserLogin(email: userTextField.text!, password: passwordTextField.text!, token: nil)
        let loginUserInteractor: LoginUserInteractor = LoginUserInteractorNSURLSessionImpl()
        
        loginUserInteractor.execute(user: userLogin) { (userLogin: UserLogin?, responseApi: ResponseApi?) in
            if userLogin == nil {
                let message = responseApi!.message
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            } else {
                //Save token in keychain
                if let token: String = userLogin?.token {
                    self.saveTokenInKeychain(token: token)
                    //Go to Events tabBar
                    let eventsTabBarController = createEventsTabBar()
                    //Configure tabbar opaque and black
                    eventsTabBarController.tabBar.isOpaque = true
                    eventsTabBarController.tabBar.barTintColor = .black
                    UIApplication.shared.keyWindow?.rootViewController = eventsTabBarController
                }
            }
        }
    }
    
    func recoverUser() {
        let userLogin = UserLogin(email: userTextField.text!, password: nil, token: nil)
        let recoverUserInteractor: RecoverUserInteractor = RecoverUserInteractorNSURLSessionImpl()
        
        recoverUserInteractor.execute(user: userLogin) { (responseApi: ResponseApi?) in
            if responseApi == nil {
                let message = "Se le ha enviado un email para recuperar su password."
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            } else {
                let message = responseApi!.message
                let alert = Alerts().alert(title: Constants.loginTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func saveTokenInKeychain(token: String) {
        //Save Token and user defaults with haslogin and username
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        UserDefaults.standard.setValue(userTextField.text, forKey: "username")
        
        do {
            // Create a new keychain item with the token.
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.serviceName,
                                              account: userTextField.text!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save token for the new item.
            try tokenItem.saveToken(token)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
