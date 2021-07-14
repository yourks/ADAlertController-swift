//
//  AlertStyleTransitionBehaviorProtocol.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

protocol AlertStyleTransitionBehaviorProtocol: NSObject {
    // 移动超出屏幕
    var moveoutScreen: Bool { get set }
}
