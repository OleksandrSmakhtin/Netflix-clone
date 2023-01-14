//
//  ViewController.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        // making a ui navigation controller for each vc
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: UpcomingVC())
        let vc3 = UINavigationController(rootViewController: SearchVC())
        let vc4 = UINavigationController(rootViewController: DownloadsVC())
        
        // change button image
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        // change button title
        vc1.title = "Home"
        vc2.title = "Coming soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        
        // change tint color
        tabBar.tintColor = .label
        
        // set controllers for the tabbar
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
    }


}

