//
//  UIViewControllerExtension.swift
//  Image Library
//
//  Created by PayTren on 12/1/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setNavBarAsPlainWhiteWithTitle(title: String = "", navbarColor: UIColor = UIColor.white) {
        self.title = title
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        let backItem = UIBarButtonItem.init()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.barTintColor = navbarColor
        
        self.navigationController?.navigationBar.tintColor = UIColor.brown
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.cyan]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.init(name: "FiraSans-Regular", size: 16)!]
    }
}
