//
//  UIDeviceExtension.swift
//  Daily News
//
//  Created by Huang Runhua on 11/15/22.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
