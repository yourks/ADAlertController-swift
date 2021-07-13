//
//  UIViewController+ADViewControllerExt.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/8.
//

import UIKit

extension UIViewController {
    
    // MARK: - public func
    
    public static func ad_topVisibleViewController() -> UIViewController {
        var rootVC: UIViewController = (UIApplication.shared.windows.filter { (UIWindow) -> Bool in
            UIWindow.isKeyWindow
        }.last?.rootViewController)!
        
        while rootVC.presentedViewController != nil {
            rootVC = rootVC.presentedViewController!

            if rootVC.isKind(of: UITabBarController.classForCoder()) {
                if let tabVC: UITabBarController = rootVC as? UITabBarController {
                    rootVC = tabVC.selectedViewController!
                }
            } else if rootVC.isKind(of: UINavigationController.classForCoder()) {
                if let navVC: UINavigationController = rootVC as? UINavigationController {
                    rootVC = navVC.presentedViewController!
                }
            } else {
                break
            }
        }
        return rootVC
    }
    
}
