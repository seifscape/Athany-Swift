//
//  AthanyTabBarController.swift
//  Athany
//
//  Created by Seif Kobrosly on 12/3/20.
//

import UIKit

class AthanyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstViewController = ViewController()
                
//        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "prayer-rug"), tag: 1)

        
        let secondViewController = ViewController()

        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "qibla-compass"), tag: 1)

        let tabBarList = [firstViewController, secondViewController]

        viewControllers = tabBarList

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
