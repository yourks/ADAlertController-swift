//
//  ADAlertControllerConst.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/28.
//

import UIKit

enum ADAlertTransitionStyle: Int {
    // presenting 转场类型
    case ADAlertTransitionStylePresenting = 0
    // dismiss 转场类型
    case ADAlertTransitionStyleDismissing = 1
}

enum ADAlertControllerStyle: Int {
    // alertview 类型
    case ADAlertControllerStyleAlert = 0
    // 与 UIKit 的 actionSheet 类型类似,保持底部,左右边距为 8
    case ADAlertControllerStyleActionSheet = 1
    // 左,右,底部边距为 0 的 actionSheet 类型
    case ADAlertControllerStyleSheet = 2
}

enum ADActionStyle: Int {
    // 默认
    case ADActionStyleDefault = 0
    // 一般
    case ADActionStyleDestructive = 1
    // 取消
    case ADActionStyleCancel = 2
    
    case ADActionStyleSheetCancel = 3
}

