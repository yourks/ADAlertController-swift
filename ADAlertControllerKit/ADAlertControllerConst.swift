//
//  ADAlertControllerConst.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/28.
//

import UIKit

/**
 1.swift的枚举,不用写一长串的前缀,
 2.没什么特殊的意义,可以不必指定枚举必须为什么类型
 3.用三个斜杠,可以变成文档注释,
 */

/// 转场动画类型
enum ADAlertTransitionStyle {
    /// presenting 转场类型
    case presenting
    /// dismiss 转场类型
    case dismissing
}

/// 警告框类型
enum ADAlertControllerStyle {
    /// alertview
    case alert
    /// 与 UIKit 的 actionSheet 类型类似,保持底部,左右边距为 8
    case actionSheet
    /// 左,右,底部边距为 0 的 actionSheet 类型
    case sheet
}

/// 按钮类型
enum ADActionStyle {
    /// 默认
    case `default`
    /// 一般
    case destructive
    /// 取消
    case cancel
    
    case sheetCancel
}

