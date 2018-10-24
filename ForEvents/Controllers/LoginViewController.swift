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
            self.passwordTextField.becomeFirstResponder()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPress(_ sender: UIButton) {
        
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
