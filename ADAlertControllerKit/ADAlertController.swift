//
//  ADAlertController.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit

typealias ADAlertDidDismissBlock = (_ alertController: ADAlertController) -> Void

typealias ADConfigurationHandlerBlock = (_ textField: UITextField) -> Void

class ADAlertController: UIViewController, ADAlertViewAlertStyleTransitionProtocol {

    // MARK: - propert/public
    
    /**
     显示在 alertTitle  的详细文本信息
     */
    public var alertTitle: String?
    
    /**
     显示在 message 的详细文本信息
     */
    public var message: String?

    /**
     允许显示的背景内容最大宽度
     */
    public var maximumWidth: CGFloat?

    /**
     包含初始化时传入的所有ADAlertAction元素的数组, actionsheet 时,不包含最底下的取消按钮cancelAction
     @see addActionSheetCancelAction:
     */
    public var actions: [ADAlertAction]?

    /**
     通过addTextFieldWithConfigurationHandler添加的 textfield 数组,
     @see addTextFieldWithConfigurationHandler:
     */
    public var textFields: [UITextField] = Array()

    /**
     自定义内容视图,默认是nil,在 alert 类型时,是显示在 titlelab 上面,actionsheet 类型时,显示在 message 下面,外部需指定高度约束,
     默认写法:[contentView.heightAnchor constraintEqualToConstant:100].active = YES宽度不得超过maximumWidth
     */
    public var contentView: UIView?
    
    // contentView 高度
    public var contentViewHeight: CGFloat?

    // ADAlertControllerViewProtocol ADAlertViewSheetStyleTransition需要
    public var mainView: ADAlertControllerViewProtocol?

    
    // MARK: - propert/private
    // ADAlertWindow
    private var alertWindow: ADAlertWindow?

    // panGestureRecognizer
    private var panGestureRecognizer: UIPanGestureRecognizer?

    // configuration 配置
    public var configuration: ADAlertControllerConfiguration?

    // ADAlertAction 按钮
    private var buttons: [UIView] = Array()

    // actionSheetCancelAction  Sheet下取消按钮
    private var actionSheetCancelAction: ADAlertAction?

    // MARK: - propert/privateShow
    // 在 alertController执行完 dismiss 之后调用的 block,用于通知优先级队列准备去显示下一个队列中的内容
    var didDismissBlock: ADAlertDidDismissBlock?

    // 当 alertController 隐藏时是否从优先级队列中移除,默认 YES,仅在显示时被其他高优先级覆盖时才置为 NO
    private var deleteWhenHiden: Bool = true
    
    // 判断是否能显示,若设置了targetViewController并且当前最顶层控制器不为targetViewController时,返回  NO,否则默认返回 YES
    private var canShow: Bool = true

    // 是否正在显示,仅在页面完全显示时才会为 YES,其余情况为 NO
    private var isShow: Bool = true
    
    /**
     是否不显示,因为在显示时是有个异步的过程,如果在还没显示时,后面又进来了一个更高优先级的警告框,那么需要将这个置为 YES,后面就不会再弹出当前警告框了,并会执行didDismissBlock
     */
    private var donotShow: Bool = true


    // MARK: - propert/ADAlertViewAlertStyleTransitionProtocol
    var moveoutScreen: Bool?

    // MARK: - init
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    // 自定义
    convenience init(configuration: ADAlertControllerConfiguration?, title: String, message: String?, actions: [ADAlertAction]?) {
        
        self.init(nibName: nil, bundle: nil)
        
        // 配置
        self.configuration = configuration ?? ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.ADAlertControllerStyleAlert)
                
        // action
        self.actions = actions
        
        // tf
        self.textFields = Array()
        
        // present model
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
        
        // 删除后隐藏
        self.deleteWhenHiden = true
        
        // 当targetViewController有值,且 alertController已经显示了,若targetViewController即将消失了,当前 alertController 是否要自动隐藏,默认 YES
        self.hidenWhenTargetViewControllerDisappear = true

        // 标题
        self.alertTitle = title
        
        // 消息
        self.message = message
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 选取样式
        switch self.configuration!.preferredStyle {
        
        case ADAlertControllerStyle.ADAlertControllerStyleAlert:
            self.mainView = ADAlertView(configuration: configuration!)
            
        case ADAlertControllerStyle.ADAlertControllerStyleSheet:
            self.mainView = ADActionSheetView(configuration: configuration!)
            
        case ADAlertControllerStyle.ADAlertControllerStyleActionSheet:
            self.mainView = ADActionSheetView(configuration: configuration!)
            
        }
        
        // addSubview
        view.addSubview(mainView!)
        // layoutView
        self.mainView?.layoutView()

        self.mainView!.contentViewHeight = contentViewHeight
        self.mainView!.contentView = contentView

        if self.actions?.count ?? 0 > 0 {
            for action: ADAlertAction in self.actions! {
                if let groupAction = action as? ADAlertGroupAction {
                    groupAction.separatorColor = self.configuration?.separatorColor
                    groupAction.showsSeparators = self.configuration?.showsSeparators
                }
                let view: UIView  = action.loadView()
                buttons.append(view)
                action.viewController = self
            }
        }
        
        // set
        self.mainView?.actionButtons = buttons
        self.mainView?.title = self.alertTitle
        self.mainView?.message = self.message
        self.mainView?.textFields = self.textFields
                
        // alert 点击事件
        if self.configuration?.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleAlert {
            self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(gestureRecognizer:)))
            
            self.panGestureRecognizer?.delegate = self 
            self.panGestureRecognizer?.isEnabled = configuration!.swipeDismissalGestureEnabled
            self.mainView?.addGestureRecognizer(self.panGestureRecognizer!)
            
            self.mainView?.textViewUserInteractionEnabled = false
        }

        if self.actionSheetCancelAction != nil {
            _  = self.actionSheetCancelAction!.loadView()
            self.mainView?.actionSheetCancelAction = self.actionSheetCancelAction
        }

        // Do any additional setup after loading the view.
    }

    // MARK: - textfield
    /**
     给 alertview 类型添加 textfield,
     ⚠️目前暂未适配键盘遮挡问题!!!
     @param configurationHandler 用于配置textfield的block。该block将textfield对象作为参数，并且可以在显示之前修改textfield的属性。
     */
    func addTextFieldWithConfigurationHandler(alertActionHandler: ADConfigurationHandlerBlock) {
        let textField: UITextField = UITextField(frame: CGRect.zero)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
           
        alertActionHandler(textField)
        
        self.textFields.append(textField)
    }

    /**
     添加 actionsheet 类型的取消按钮,用于显示在最底下的那个按钮

     @param cancelAction 取消按钮动作类型
     */
    func addActionSheetCancelAction(cancelAction: ADAlertAction) {
        self.actionSheetCancelAction = cancelAction
        self.actionSheetCancelAction?.viewController = self
        if let groupAction = cancelAction as? ADAlertGroupAction {
            groupAction.separatorColor = self.configuration?.separatorColor
            groupAction.showsSeparators = self.configuration?.showsSeparators
        }
    }
}


// MARK: - extension : UIGestureRecognizerDelegate
extension ADAlertController: UIGestureRecognizerDelegate {
    
    @objc func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {

        if self.mainView!.isKind(of: ADAlertView.classForCoder()) {

            let view: ADAlertView = self.mainView! as! ADAlertView

            let offest: CGFloat = gestureRecognizer.translation(in: self.mainView).y//

            view.snp.updateConstraints { (constraintMaker) in
                constraintMaker.centerY.equalToSuperview().offset(offest)
            }
            let presnetVC: ADAlertControllerPresentationController = self.presentationController as! ADAlertControllerPresentationController

            let windowHeight: CGFloat = ADAlertWindow.window().bounds.size.height
            presnetVC.backgroundView?.alpha = 1 - (abs(gestureRecognizer.translation(in: self.mainView).y) / windowHeight)
            if gestureRecognizer.state == UIGestureRecognizer.State.ended {
                let verticalGestureVelocity: CGFloat = gestureRecognizer.translation(in: self.mainView).y

                var backgroundViewYPosition: CGFloat = 0.0

                if abs(verticalGestureVelocity) > 500.0 {
                    if verticalGestureVelocity > 500.0 {
                        backgroundViewYPosition = self.view.frame.size.height
                    } else {
                        backgroundViewYPosition = -self.view.frame.size.height
                    }
                    let animationDuration: CGFloat = 500.0 / abs(verticalGestureVelocity)

                    view.snp.updateConstraints { (constraintMaker) in
                        constraintMaker.centerY.equalToSuperview().offset(backgroundViewYPosition)
                    }

                    UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.init()) {
                        presnetVC.backgroundView?.alpha = 0.0
                        self.mainView!.layoutIfNeeded()
                    } completion: { (_) in
                        self.moveoutScreen = true
                        self.dismiss(animated: true) {
                            view.snp.updateConstraints { (constraintMaker) in
                                constraintMaker.centerY.equalToSuperview().offset(0.0)
                            }
                            self.moveoutScreen = false
                        }
                    
                    }
                } else {
                    view.snp.updateConstraints { (constraintMaker) in
                        constraintMaker.centerY.equalToSuperview().offset(0.0)
                    }
                    UIView.animate(withDuration: TimeInterval(0.5), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: UIView.AnimationOptions.init()) {
                        presnetVC.backgroundView?.alpha = 1.0
                        self.mainView!.layoutIfNeeded()
                    } completion: { (_) in}
                }
            }

        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isKind(of: UIButton.classForCoder()) == true {
            return false
        }
        return true
    }
    
}

// MARK: - extension : ADAlertControllerPriorityQueueProtocol
extension ADAlertController: ADAlertControllerPriorityQueueProtocol {
    
    private struct AssociatedKeys {
        static var alertPriority: Void?
        static var autoHidenWhenInsertSamePriority: Void?
        static var targetViewController: Void?
        static var hidenWhenTargetViewControllerDisappear: Void?
    }
        
    var alertPriority: ADAlertPriority {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.alertPriority) as! ADAlertPriority
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.alertPriority, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var autoHidenWhenInsertSamePriority: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.autoHidenWhenInsertSamePriority) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.autoHidenWhenInsertSamePriority, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var targetViewController: UIViewController {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.targetViewController) as! UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.targetViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var hidenWhenTargetViewControllerDisappear: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hidenWhenTargetViewControllerDisappear) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.hidenWhenTargetViewControllerDisappear, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    func enqueue() {
        
    }
    
    func cleanQueueAllObject() {
        
    }
    
    func show() {
        let alertWindow =  ADAlertWindow.window()
        self.alertWindow = alertWindow
        alertWindow.presentViewController(viewController: self) {}
    }
    
    func hiden() {
        ADAlertController.hidenAlertVC(viewController: self)
    }
    
    
    // MARK: - static和class都能指定该方法为类方法
    static func hidenAlertVC(viewController: ADAlertController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func clearUp() {
        self.alertWindow?.isHidden = true
        self.alertWindow?.cleanUpWithViewController()
        if self.didDismissBlock != nil { self.didDismissBlock!(self)}
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.presentationController != nil {
            super.dismiss(animated: flag) {
                if completion != nil {completion!()}
                self.clearUp()
            }
        } else {
            self.clearUp()
        }
    }
    
}
