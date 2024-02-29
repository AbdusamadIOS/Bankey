//
//  UIViewController+Utils.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 29/02/24.
//

import UIKit

extension UIViewController {
    func setStatusBar() {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let frame = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView = UIView(frame: frame)
        
        statusBarView.backgroundColor = appColor
        view.addSubview(statusBarView)
    }
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
    
}

//extension UIViewController {
//    func setStatusBar() {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground() // to hide Navigation Bar Line also
//        navBarAppearance.backgroundColor = appColor
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//    }
//}
