//
//  createTabBar.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit

func createLoginTabBar() -> UITabBarController {
    
    let firstVC = LoginViewController()
    let secondVC = RegisterViewController()
    
    let tabBarList = UITabBarController()
    
    firstVC.tabBarItem =
        UITabBarItem(title: "Inicio sesión", image: nil, tag: 0)
    
    secondVC.tabBarItem = UITabBarItem(title: "Registro", image: nil, tag: 1)
    
    tabBarList.viewControllers = [firstVC, secondVC]
    
    //Configure text of tabbaritem
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 166/255, blue: 89/255, alpha: 1), NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 15) as Any], for: .selected)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 15) as Any], for: .normal)
    
    return tabBarList
}

func createEventsTabBar() -> UITabBarController {
    
    //Configure EventsTabBarController
    let firstVC = EventsViewController().wrappedInNavigation()
    let secondVC = MapViewController().wrappedInNavigation()
    let thirdVC = NotificationsViewController().wrappedInNavigation()
    let fourthVC = ProfileViewController().wrappedInNavigation()
    
    let tabBarList = UITabBarController()
    
    firstVC.tabBarItem =
        UITabBarItem(title: "Eventos", image: UIImage(named: "today-50"), tag: 0)
    
    secondVC.tabBarItem = UITabBarItem(title: "Mapa Eventos", image: UIImage(named: "map-marker-50"), tag: 1)
    
    thirdVC.tabBarItem = UITabBarItem(title: "Notificaciones", image: UIImage(named: "bell-50"), tag: 2)
    
    fourthVC.tabBarItem = UITabBarItem(title: "Perfil usuario", image: UIImage(named: "contacts-50"), tag: 3)
    
    tabBarList.viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
   
    //Configure text of tabbaritem
        let selectedColor = UIColor(red: 255/255, green: 166/255, blue: 89/255, alpha: 1)
        let unselectedColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
   
        UITabBar.appearance().tintColor = selectedColor
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 12) as Any], for: .selected)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor,NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 12) as Any], for: .normal)
    
    return tabBarList
}
