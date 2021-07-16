//
//  ADAlertControllerViewProtocol.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit



protocol ADAlertControllerViewProtocol: UIView {
    // 协议内容
    // 标题
    var title: String? {get set}
    // 消息
    var message: String? {get set}
    // 最大宽度
    var maximumWidth: CGFloat? {get set}
    // 所有UI 元素的容器视图
    var backgroundContainerView: UIView? {get set}
    // 自定义 contentview,可自定义,需指定高度约束,宽度不指定,会自动与maximumWidth保持一致
    var contentView: UIView? {get set}
    // 高度指定
    var contentViewHeight: CGFloat? {get set}
    // 包含按钮的所有数组,actionsheet类型时不包含取消按钮,要通过-addCancelButton:添加
    var actionButtons: [UIView]? { get set}
    // textfield 数组, 仅限在ADAlertControllerStyleAlert中有效
    var textFields: [UITextField]? {get set}

    var textViewUserInteractionEnabled: Bool? {get set}
    
    var actionSheetCancelAction: ADAlertAction? {get set}

    init(configuration: ADAlertControllerConfiguration)

    func layoutView()
    // 留待观察
    //    + (instancetype)new NS_UNAVAILABLE
    //    - (instancetype)init NS_UNAVAILABLE
    //    - (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE
    //    - (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE

}

enum ADAlertPriority: Int {
    // 默认层级
    case ADAlertPriorityDefault = 10
    // 高优先级
    case ADAlertPriorityHight = 100
    // 最高优先级
    case ADAlertPriorityRequire = 1000
}


protocol ADAlertControllerBaseProtocol {
    
    func show()
    
    func hiden()

}

// AlertController 实现优先级队列须遵循的协议,继承自ADAlertControllerBaseProtocol
protocol ADAlertControllerPriorityQueueProtocol: ADAlertControllerBaseProtocol {
    
    // 优先级属性,可以设置任意从 0 到 NSUIntegerMax之间的任意数,不仅限于ADAlertPriority枚举内的三个数,
    // 但是需要自己把握优先级数,在队列中是比较此属性的值来排列优先级,值越大,越优先显示
    var alertPriority: ADAlertPriority {get set}

    // 当插入一个同优先级的 alertController 时,当前 alertController是否自动隐藏,
    // 一般配合deleteWhenHiden使用,使当前自动隐藏的alertController后面还有机会显示,默认 NO
    var autoHidenWhenInsertSamePriority: Bool {get set}

    // 当前alertController是否仅在targetViewController为最顶部的控制器时才显示,
    // 若有值,则仅当 targetViewController 为最顶层控制器,且当前 alertController 是队列中的最高优先级时才会显示,
    // 默认nil,表示在任意页面都可显示
    var targetViewController: UIViewController? {get set}

    //  当targetViewController有值,且 alertController已经显示了,若targetViewController即将消失了,当前 alertController 是否要自动隐藏,默认 YES
    var hidenWhenTargetViewControllerDisappear: Bool {get set}
    
    // 入优先级队列去等待显示
    func enqueue()

    // 清空优先级队列中的所有对象
    func cleanQueueAllObject()

}



