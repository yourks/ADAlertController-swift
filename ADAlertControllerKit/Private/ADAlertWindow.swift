//
//  ADAlertWindow.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit

 

let ADTAlertWindowLevel = 10.0
class ADAlertWindowRootViewController: UIViewController {
    
    // MARK: - func/private/override
    deinit {
        // print("dealloc \(NSStringFromClass(self.classForCoder))")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
}


class ADAlertWindow: UIWindow {

    // MARK: - static internal func
    static internal func windowAlertViewControllerMapTable() -> NSMapTable<AnyObject, AnyObject> {
        struct Static {
            // Singleton instance. Initializing keyboard manger.
            static let windowAlertVCMapTables: NSMapTable = NSMapTable<AnyObject, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
        }
        return Static.windowAlertVCMapTables
    }
    
    // 不行
//    final func windowAlertViewControllerMapTable() -> NSMapTable<AnyObject, AnyObject>  {
//        static let share :NSMapTable = windowAlertViewControllerMapTable()
//        private init(){
//
//        }
//    }
    
    // MARK: - public
    public func cleanUpWithViewController() {
        ADAlertWindow.windowAlertViewControllerMapTable().removeAllObjects()
    }
    
    static public func window() -> ADAlertWindow {
        
        let window: ADAlertWindow = ADAlertWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.init(CGFloat(ADTAlertWindowLevel))
        let rootVc: ADAlertWindowRootViewController = ADAlertWindowRootViewController()
        window.rootViewController = rootVc
        return window
    }

    internal func presentViewController(viewController: UIViewController?, completion: (() -> Void)? = nil) {

        if viewController == nil {
            return
        }

        if ADAlertWindow.windowAlertViewControllerMapTable().object(forKey: viewController) == nil {
            self.isHidden = false
            self.makeKeyAndVisible()
            self.rootViewController?.present(viewController!, animated: true, completion: {})
            
            ADAlertWindow.windowAlertViewControllerMapTable() .setObject(self, forKey: viewController!)
        }

    }
}
