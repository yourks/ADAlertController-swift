//
//  UIImage+ADImageExt.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/8.
//

import UIKit

extension UIImage {
    
    //MARK: - public func
    
    public static func ad_imageWithTheColor(color :UIColor) -> UIImage {
        let rect :CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image :UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
