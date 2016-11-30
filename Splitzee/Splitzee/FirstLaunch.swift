//
//  FirstLaunch.swift
//  Splitzee
//
//  Created by Mohit Katyal on 11/29/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import Foundation
import UIKit

let isFirstLaunch = UserDefaults.isFirstLaunch()

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
            return true
            
        }
        return false
    }
    
}
