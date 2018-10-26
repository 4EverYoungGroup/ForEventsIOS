//
//  createTabBar.swift
//  ForEvents
//
//  Created by luis gomez alonso on 26/10/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit

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
    
    UITabBar.appearance().tintColor = .black
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: [.normal])
    
    return tabBarList
}
