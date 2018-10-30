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
        
        //Configure text of tabbaritem
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 166/255, blue: 89/255, alpha: 1), NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 15) as Any], for: .selected)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 15) as Any], for: .normal)

        let firstVC = LoginViewController()
        let secondVC = RegisterViewController()
        
        firstVC.tabBarItem =
            UITabBarItem(title: "Inicio sesión", image: nil, tag: 0)
        
        secondVC.tabBarItem = UITabBarItem(title: "Registro", image: nil, tag: 1)
        
        let tabBarList = [firstVC, secondVC]
        
        viewControllers = tabBarList
    }
    
}
