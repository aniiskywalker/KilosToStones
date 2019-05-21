//
//  Extensions.swift
//  KgToStones
//
//  Created by Ana Victoria Frias on 5/20/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
