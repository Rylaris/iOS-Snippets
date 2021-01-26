//
//  UIViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//

import UIKit

extension UIViewController {
    /// 返回当前的View Controller
    ///
    /// - Parameter base: 迭代起点
    /// - Returns: 当前的View Controller
    static func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }
}
