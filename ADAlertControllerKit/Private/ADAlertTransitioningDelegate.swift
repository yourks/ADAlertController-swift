//
//  ADAlertTransitioningDelegate.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/5.
//

import UIKit

protocol ADAlertTransitioningDelegate: NSObject {
    
    /**
     alertAction 显示的标题字体,默认为[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
     */
    var titleFont: UIFont? { get set }

}

