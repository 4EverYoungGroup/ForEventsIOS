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
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().alpha = 0.3
        
        let firstVC = LoginViewController()
        let secondVC = RegisterViewController()
        
        firstVC.tabBarItem =
            UITabBarItem(title: "Inicio sesión", image: nil, tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "Registro", image: nil, tag: 1)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)], for: [.normal])
        
        let tabBarList = [firstVC, secondVC]
        
        viewControllers = tabBarList
    }
    
}
