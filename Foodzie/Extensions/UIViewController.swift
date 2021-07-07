//
//  UIViewController.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiate(nibName: String? = nil, bundle: Bundle? = nil) -> Self {
        return Self.init(nibName: nibName ?? String(describing: self), bundle: bundle)
    }
    
}

