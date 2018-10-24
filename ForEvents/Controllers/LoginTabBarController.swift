//
//  LoginTabBarController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit

class LoginTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Configure loginTabBarController
        let firstVC = LoginViewController()
        let secondVC = RegisterViewController()
        
        firstVC.tabBarItem =
            UITabBarItem(title: "Inicio sesión", image: nil, tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "Registro", image: nil, tag: 1)
        
        UITabBar.appearance().tintColor = .black
        
        let tabBarList = [firstVC, secondVC]
        
        viewControllers = tabBarList
    }
    
}
