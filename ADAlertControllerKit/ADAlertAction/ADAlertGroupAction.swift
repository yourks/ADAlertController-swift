//
//  ADAlertGroupAction.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertGroupAction: ADAlertAction {

    // MARK: - proprety/pubilc
    
    // 分割线颜色
    public var separatorColor: UIColor?
    // 分割线是否显示
    public var showsSeparators: Bool?

    // MARK: - proprety/private
    
    // Array ADAlertAction
    var actions: [ADAlertAction]?
    
    // UIStackView
    var actionButtonStackView: UIStackView?

    // 重写viewController
    internal override var viewController: UIViewController? {
        didSet {
            for action in self.actions! {
                action.viewController = viewController
            }
        }
    }
    
    // MARK: - func init
    override init() {
        super.init()
    }
    
    // MARK: - static func
    static func groupActionWithActions(actions: [ADAlertAction]) -> ADAlertGroupAction {
                
        var condition: Bool = false
        var message: String = ""
        if actions.count == 0 {
            condition = true
            message = "Tried to initialize ADAlertGroupAction with less than one action."
        }

        if actions.count == 1 {
            condition = true
            message = "Tried to initialize ADAlertGroupAction with one action. Use ADAlertAction in this case."
        }

        for action in actions {
            if action.isKind(of: ADAlertAction.classForCoder()) == false {
                condition = true
                message = "Tried to initialize ADAlertGroupAction with objects of types other than ADAlertAction."
            }
        }

        if condition == true, message.count > 0 {
            precondition(condition, message)
        }
        
        let groupAction: ADAlertGroupAction = ADAlertGroupAction()
        groupAction.actions = actions
        
        // FIXME: NSException
        return groupAction
    }
    
    // MARK: - override func
    override public func loadView() -> UIView {
        
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        self.actionButtonStackView = UIStackView()
        self.actionButtonStackView?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        self.actionButtonStackView?.spacing = 0.0
        view.addSubview(self.actionButtonStackView!)
        self.actionButtonStackView?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        })
        
        actionButtonStackView?.axis = NSLayoutConstraint.Axis.horizontal
        actionButtonStackView?.alignment = UIStackView.Alignment.fill
        actionButtonStackView?.distribution = UIStackView.Distribution.fillEqually
        self.actionButtonStackView?.layoutIfNeeded()

        for action: ADAlertAction in self.actions! {
            self.actionButtonStackView!.addArrangedSubview(action.loadView())
        }

        return view
    }
    
    // FIXME: NSException
    // MARK: - func overriride
    //https://www.jianshu.com/p/84edfd5b30dd/
    //https://www.jianshu.com/p/87fb293a70b8?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
    //http://www.zyiz.net/tech/detail-117055.html
//    + (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler{
//        [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))]
//        return nil
//    }

    
}
