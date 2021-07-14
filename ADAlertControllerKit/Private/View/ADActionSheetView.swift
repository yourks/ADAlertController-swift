//
//  ADActionSheetView.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/29.
//

import UIKit



class ADActionSheetView: UIView, ADAlertControllerViewProtocol {
    
    // MARK: - proprety/private
    
    // 标题 label
    private var titleLabel: ADAlertTitleLabel? {
        didSet {
            titleLabel?.text = title
        }
    }

    // 标题 textview
    private var messageTextView: ADAlertTextView?
    // 内容视图
    private var contentViewContainerView: UIView?
    // 按钮包含视图
    private var actionButtonContainerView: UIView?
    // 按钮视图
    private var actionButtonStackView: UIStackView?
    // 分割线
    private var separatorView: UIView?
    
    // 顶部视图
    private var topView: UIView?
    // 底部视图
    private var bottomView: UIView?
    // 底部按钮视图
    private var bottomactionButtonStackView: UIStackView?

    // 配置ADAlertControllerConfiguration
    private var configuration: ADAlertControllerConfiguration?

    
    // MARK: - propert/protrocal
    
    // 标题
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    // 消息
    var message: String? {
        willSet {
            if newValue?.count ?? 0 == 0 {
                messageTextView!.snp.remakeConstraints { (constraintMaker) in
                    constraintMaker.left.equalToSuperview().offset(15)
                    constraintMaker.right.equalToSuperview().offset(-15)
                    constraintMaker.top.equalTo(titleLabel!.snp_bottom).offset(0)
                    constraintMaker.height.greaterThanOrEqualTo(0)
                }
            }
        }
        didSet {
            messageTextView?.text = message
            messageTextView?.textContainerInset = configuration!.messageTextInset
        }
    }
    // 最大
    var maximumWidth: CGFloat?
    // 背景视图
    var backgroundContainerView: UIView?
    // 内容视图高度
    var contentViewHeight: CGFloat?
    // 内容
    var contentView: UIView? {
        didSet {
            if contentView == nil {
                return
            }
            
            if contentViewHeight == nil, contentViewHeight ?? 0 <= 0 {
                contentViewHeight = 250
            }

            contentViewContainerView?.addSubview(contentView!)
            contentViewContainerView?.snp.updateConstraints { (constraintMaker) in
                constraintMaker.height.greaterThanOrEqualTo(contentViewHeight!)
            }
            contentView?.snp.makeConstraints({ (constraintMaker) in
                constraintMaker.edges.equalToSuperview()
            })


            contentViewContainerView?.layoutIfNeeded()
            contentView?.layoutIfNeeded()
        }
    }
    // 按钮
    var actionButtons: [UIView]? {
        
        didSet {
            for view: UIView in actionButtonStackView!.arrangedSubviews {
                view.removeFromSuperview()
            }

            if actionButtons?.count == 0 {
                separatorView?.isHidden = true
                return
            }
            
            separatorView?.isHidden = false
            
            for index: Int in 0..<actionButtons!.count {
                if configuration?.alertActionsViewBtnBackgroundColors.count ?? 0 > index {
                    actionButtons?[index].backgroundColor = configuration?.alertActionsViewBtnBackgroundColors[index]
                } else {
                    actionButtons?[index].backgroundColor = UIColor.white
                }

                var actionButtonContainerViewHeight: CGFloat = 40.0
                    actionButtonContainerViewHeight = 40.0 * CGFloat(actionButtons!.count)
                    actionButtonStackView?.axis = NSLayoutConstraint.Axis.vertical
                    actionButtonStackView?.alignment = UIStackView.Alignment.fill
                    actionButtonStackView?.distribution = UIStackView.Distribution.fillEqually
                
                actionButtonContainerView?.snp.remakeConstraints { (constraintMaker) in
                    constraintMaker.left.equalToSuperview()
                    constraintMaker.right.equalToSuperview()
                    constraintMaker.top.equalTo(contentViewContainerView!.snp_bottom).offset(15)
                    constraintMaker.height.greaterThanOrEqualTo(actionButtonContainerViewHeight)
                    constraintMaker.bottom.equalToSuperview()
                }
                
                actionButtons?[index].setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
                actionButtonStackView!.addArrangedSubview(actionButtons![index])
            }
        }
    }
    // textView能否滚动
    var textViewUserInteractionEnabled: Bool? {
        didSet {
            self.messageTextView?.isUserInteractionEnabled = textViewUserInteractionEnabled ?? false
        }
    }
    // textFields
    var textFields: [UITextField]?
    // 取消按钮
    var actionSheetCancelAction: ADAlertAction? {
        didSet {
            for view: UIView in bottomactionButtonStackView!.arrangedSubviews {
                view.removeFromSuperview()
            }

            if actionSheetCancelAction == nil {
                separatorView?.isHidden = true
                return
            }
            
            separatorView?.isHidden = false
            
            actionSheetCancelAction?.button?.backgroundColor = UIColor.white

            let actionButtonContainerViewHeight = 40.0
            bottomactionButtonStackView?.axis = NSLayoutConstraint.Axis.vertical
            bottomactionButtonStackView?.alignment = UIStackView.Alignment.fill
            bottomactionButtonStackView?.distribution = UIStackView.Distribution.fillEqually

            bottomView?.snp.remakeConstraints { (constraintMaker) in
                constraintMaker.left.equalToSuperview().offset(0)
                constraintMaker.right.equalToSuperview().offset(0)
                constraintMaker.top.equalTo(topView!.snp_bottom).offset(5)
                constraintMaker.height.greaterThanOrEqualTo(actionButtonContainerViewHeight)
                constraintMaker.bottom.equalToSuperview().offset(-15)
            }
            
            actionSheetCancelAction?.button?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
            bottomactionButtonStackView!.addArrangedSubview(actionSheetCancelAction!.button!)
        }
    }

    // MARK: - init
    internal init() {
        super.init(frame: CGRect.zero)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(configuration: ADAlertControllerConfiguration) {
        
        self.init()
        
        self.configuration = configuration
    
        var maxWidth: CGFloat = UIScreen.main.bounds.size.width
        
        if configuration.preferredStyle == ADAlertControllerStyle.actionSheet {
            maxWidth -= (ADActionSheetStyleLeadingTrailingPad * 2)
        }
        self.maximumWidth = maxWidth
        
        // backgroundContainerView
        backgroundContainerView = UIView(frame: CGRect.zero)
        backgroundContainerView?.clipsToBounds = true
        backgroundContainerView?.layer.cornerRadius = configuration.alertViewCornerRadius
        backgroundContainerView?.backgroundColor = UIColor.clear
        backgroundContainerView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundContainerView!)

        // 顶部容器视图
        topView = UIView(frame: CGRect.zero)
        topView?.clipsToBounds = true
        topView?.layer.cornerRadius = configuration.alertViewCornerRadius
        topView?.backgroundColor = configuration.alertContainerViewBackgroundColor
        topView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView?.addSubview(topView!)

        // 底部容器视图
        bottomView = UIView(frame: CGRect.zero)
        bottomView?.clipsToBounds = true
        bottomView?.layer.cornerRadius = configuration.alertViewCornerRadius
        bottomView?.backgroundColor = configuration.alertContainerViewBackgroundColor
        bottomView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView?.addSubview(bottomView!)

        // title
        titleLabel = ADAlertTitleLabel(frame: CGRect.zero)
        //        _titleLabel.textInset = UIEdgeInsetsMake(20, 0, 10, 0)
        titleLabel?.contentCompressionResistancePriority(for: NSLayoutConstraint.Axis.vertical)
        titleLabel?.numberOfLines = 2
        if configuration.titleFont != nil {
            titleLabel?.font = configuration.titleFont
        }
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = configuration.titleTextColor
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(titleLabel!)

        // messageTextView
        messageTextView = ADAlertTextView(frame: CGRect.zero)
        messageTextView?.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        messageTextView?.contentCompressionResistancePriority(for: NSLayoutConstraint.Axis.vertical)
        messageTextView?.backgroundColor = UIColor.clear
        messageTextView?.isEditable = false
        messageTextView?.isSelectable = false
        if configuration.messageFont != nil {
            messageTextView?.font = configuration.messageFont
        }
        messageTextView?.font = UIFont.systemFont(ofSize: 15)
        messageTextView?.textContainer.lineFragmentPadding = 0.0
        messageTextView?.textContainerInset = UIEdgeInsets.zero
        
        messageTextView?.textAlignment = NSTextAlignment.center
        messageTextView?.textColor = configuration.titleTextColor
        messageTextView?.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(messageTextView!)

        // contentViewContainerView
        contentViewContainerView = UIView(frame: CGRect.zero)
        contentViewContainerView?.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(contentViewContainerView!)

        // actionButtonContainerView
        actionButtonContainerView = UIView(frame: CGRect.zero)
        actionButtonContainerView? .setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        actionButtonContainerView?.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(actionButtonContainerView!)

        // actionButtonStackView
        actionButtonStackView = UIStackView()
        actionButtonStackView?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        actionButtonStackView?.spacing = 0.0
        actionButtonContainerView?.addSubview(actionButtonStackView!)

        // bottomactionButtonStackView
        bottomactionButtonStackView = UIStackView()
        bottomactionButtonStackView?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        bottomactionButtonStackView?.spacing = 0.0
        bottomView?.addSubview(bottomactionButtonStackView!)

        // 显示分割线
        if configuration.showsSeparators == true {
            actionButtonStackView?.spacing = 0.5
            actionButtonStackView!.backgroundColor = configuration.separatorColor
            separatorView = UIView()
            separatorView?.backgroundColor = configuration.separatorColor
            separatorView?.translatesAutoresizingMaskIntoConstraints = false
            actionButtonContainerView?.addSubview(separatorView!)
        }
    
    }

    
    // MARK: - layoutView
    func layoutView() {
//        self.backgroundColor = UIColor.yellow
//        backgroundContainerView?.backgroundColor = UIColor.red
//        topView?.backgroundColor = UIColor.white
//        bottomView?.backgroundColor = UIColor.green
//       bottomactionButtonContainerView?.backgroundColor = UIColor.orange
//        bottomactionButtonStackView?.backgroundColor = UIColor.black
//
//                titleLabel?.backgroundColor = UIColor.gray
//                messageTextView?.backgroundColor = UIColor.yellow
//                contentViewContainerView?.backgroundColor = UIColor.purple
//                actionButtonContainerView?.backgroundColor = UIColor.red
//                actionButtonContainerView?.backgroundColor = UIColor.green
//        actionButtonStackView?.backgroundColor = UIColor.green
//        separatorView?.backgroundColor = UIColor.gray
        
        // 添加约束
        self.snp.makeConstraints { (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.centerY.equalToSuperview().offset(0)
            constraintMaker.width.equalToSuperview()
            constraintMaker.height.equalToSuperview()
        }
        
        backgroundContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.width.equalTo(maximumWidth!)
            constraintMaker.bottom.equalToSuperview()
            constraintMaker.height.greaterThanOrEqualTo(15+20+15+5+40+15)
        }

        topView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(0)
            constraintMaker.right.equalToSuperview().offset(0)
            constraintMaker.top.equalToSuperview().offset(0)
            constraintMaker.height.greaterThanOrEqualTo(15+20+15)
        }

        titleLabel?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalToSuperview().offset(15)
            constraintMaker.height.greaterThanOrEqualTo(0)
        }

        messageTextView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalTo(titleLabel!.snp_bottom).offset(15)
            constraintMaker.height.greaterThanOrEqualTo(20)
        }

        contentViewContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalTo(messageTextView!.snp_bottom).offset(0)
            constraintMaker.height.greaterThanOrEqualTo(0)
        }
        
        actionButtonContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.top.equalTo(contentViewContainerView!.snp_bottom).offset(15)
            constraintMaker.height.greaterThanOrEqualTo(0)
            constraintMaker.bottom.equalToSuperview()
        }

        actionButtonStackView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalToSuperview().offset(0.5)
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.bottom.equalToSuperview()
        }
        
        bottomView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(0)
            constraintMaker.right.equalToSuperview().offset(0)
            constraintMaker.top.equalTo(topView!.snp_bottom).offset(0)
            constraintMaker.height.greaterThanOrEqualTo(0)
            constraintMaker.bottom.equalToSuperview()
        }

        bottomactionButtonStackView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalToSuperview().offset(0.5)
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.bottom.equalToSuperview()
        }

        if (self.configuration?.showsSeparators) != nil {
            separatorView?.snp.makeConstraints { (constraintMaker) in
                constraintMaker.left.equalToSuperview()
                constraintMaker.right.equalToSuperview()
                constraintMaker.top.equalToSuperview()
                constraintMaker.height.equalTo(0.5)
            }
        }
        
        messageTextView?.layoutIfNeeded()
        backgroundContainerView?.layoutIfNeeded()
        self.layoutIfNeeded()
    }
}
