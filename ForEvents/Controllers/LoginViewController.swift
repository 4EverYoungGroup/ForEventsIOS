//
//  LoginViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
    
    func validateLogin() -> Bool {
        //email format validate
        if !(userTextField.text?.isValidEmail())! {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "El dato de usuario debe de ser un email válido.")
            self.userTextField.becomeFirstResponder()
            self.present(alert, animated: true, completion: nil)
            return false
        }
        //passwords is valid, must include uppercase, lowercase and digits and 6 long min
        if (passwordTextField.text?.isEmpty)! {
            let alert = Alerts().alert(title: Constants.alertTitle, message: "La password es obligatoria.")
            self.passwordTextField.becomeFirstResponder()
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
                let alert = Alerts().alert(title: Constants.alertTitle, message: message)
                self.userTextField.becomeFirstResponder()
                self.present(alert, animated: true, completion: nil)
            } else {
                //Save token in keychain
                if let token: String = userLogin?.token {
                    print ("Token: ", token)
                }
            }
        }
    }
    
    func createEventsTabBar() -> UITabBarController {
        
        //Configure EventsTabBarController
        let firstVC = EventsViewController().wrappedInNavigation()
        let secondVC = MapViewController().wrappedInNavigation()
        let thirdVC = NotificationsViewController().wrappedInNavigation()
        let fourthVC = ProfileViewController().wrappedInNavigation()
        
        let tabBarList = UITabBarController()
        
        firstVC.tabBarItem =
            UITabBarItem(title: "Eventos", image: nil, tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "Mapa de Eventos", image: nil, tag: 1)
        
        thirdVC.tabBarItem = UITabBarItem(title: "Notificaciones", image: nil, tag: 2)
        
        fourthVC.tabBarItem = UITabBarItem(title: "Perfil usuario", image: nil, tag: 3)
        
        tabBarList.viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        
        return tabBarList
    }

}
