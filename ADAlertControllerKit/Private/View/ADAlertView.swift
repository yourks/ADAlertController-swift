//
//  ADAlertView.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit
import SnapKit

class ADAlertView: UIView, ADAlertControllerViewProtocol {
 
    // MARK: - propert/private
    
    // titleLab
    private var titleLabel: ADAlertTitleLabel?
    
    // messageTextView
    private var messageTextView: ADAlertTextView?
    
    // contentViewContainerView
    private var contentViewContainerView: UIView?
    
    // textFieldContainerView
    private var textFieldContainerView: UIView?
    
    // actionButtonContainerView
    private var actionButtonContainerView: UIView?
    
    // actionButtonStackView
    private var actionButtonStackView: UIStackView?

    // separatorView
    private var separatorView: UIView?
    
    // alertBackgroundWidthConstraint
    private var alertBackgroundWidthConstraint: NSLayoutConstraint?
    
    // configuration
    private var configuration: ADAlertControllerConfiguration?

    // MARK: - propert/protrocal
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    
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
    
    var maximumWidth: CGFloat?
    
    var backgroundContainerView: UIView?

    var contentViewHeight: CGFloat?

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
                if actionButtons!.count <= 2 {
                    actionButtonContainerViewHeight = 40.0
                    actionButtonStackView?.axis = NSLayoutConstraint.Axis.horizontal
                    actionButtonStackView?.alignment = UIStackView.Alignment.fill
                    actionButtonStackView?.distribution = UIStackView.Distribution.fillEqually
                } else {
                    actionButtonContainerViewHeight = 40.0 * CGFloat(actionButtons!.count)
                    actionButtonStackView?.axis = NSLayoutConstraint.Axis.vertical
                    actionButtonStackView?.alignment = UIStackView.Alignment.fill
                    actionButtonStackView?.distribution = UIStackView.Distribution.fillEqually
                }
                
                actionButtonContainerView?.snp.remakeConstraints { (constraintMaker) in
                    constraintMaker.left.equalToSuperview()
                    constraintMaker.right.equalToSuperview()
                    constraintMaker.top.equalTo(textFieldContainerView!.snp_bottom).offset(15)
                    constraintMaker.height.greaterThanOrEqualTo(actionButtonContainerViewHeight)
                    constraintMaker.bottom.equalToSuperview()
                }
                
                actionButtons?[index].setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
                actionButtonStackView!.addArrangedSubview(actionButtons![index])
            }
        }
    }
    
    var textFields: [UITextField]? {

        didSet {
            for textField: UITextField in textFields! {
                textField.removeFromSuperview()
            }

            var topOffset = 0
            for index: NSInteger in 0..<textFields!.count {
                let textField: UITextField = textFields![index]
                textField.translatesAutoresizingMaskIntoConstraints = false
                self.textFieldContainerView?.addSubview(textField)
                
                topOffset = 10 + index*(40 + 5)
                
                textField.snp.makeConstraints { (constraintMaker) in
                    constraintMaker.left.right.equalToSuperview()
                    constraintMaker.top.equalToSuperview().offset(topOffset)
                    constraintMaker.height.equalTo(40)
                }
            }

            self.textFieldContainerView?.snp.remakeConstraints({ (constraintMaker) in
                constraintMaker.left.equalToSuperview().offset(15)
                constraintMaker.right.equalToSuperview().offset(-15)
                constraintMaker.top.equalTo(contentViewContainerView!.snp_bottom).offset(0)
                constraintMaker.height.greaterThanOrEqualTo(10+40+(40+5)*(textFields!.count-1)+10)
            })
        }
    }
    
    var textViewUserInteractionEnabled: Bool? {
        didSet {
            self.messageTextView?.isUserInteractionEnabled = textViewUserInteractionEnabled ?? false
        }
    }
    
    var actionSheetCancelAction: ADAlertAction?
    
    // MARK: - init
    required convenience init(configuration: ADAlertControllerConfiguration) {
        
        self.init()
        
        self.configuration = configuration
        
        maximumWidth = UIScreen.main.bounds.size.width - 40

        // backgroundContainerView
        backgroundContainerView = UIView(frame: CGRect.zero)
        backgroundContainerView?.clipsToBounds = true
        backgroundContainerView?.layer.cornerRadius = configuration.alertViewCornerRadius
        backgroundContainerView?.backgroundColor = configuration.alertContainerViewBackgroundColor
        backgroundContainerView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundContainerView!)
        
        // titleLabel
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
        backgroundContainerView?.addSubview(titleLabel!)

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
        backgroundContainerView?.addSubview(messageTextView!)

        // contentViewContainerView
        contentViewContainerView = UIView(frame: CGRect.zero)
        contentViewContainerView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView?.addSubview(contentViewContainerView!)

        // contentViewContainerView
        textFieldContainerView = UIView(frame: CGRect.zero)
        textFieldContainerView? .setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        textFieldContainerView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView?.addSubview(textFieldContainerView!)

        // actionButtonContainerView
        actionButtonContainerView = UIView(frame: CGRect.zero)
        actionButtonContainerView? .setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        actionButtonContainerView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView?.addSubview(actionButtonContainerView!)

        // actionButtonStackView
        actionButtonStackView = UIStackView()
        actionButtonStackView?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        actionButtonStackView?.spacing = 0.0
        actionButtonContainerView?.addSubview(actionButtonStackView!)

        // 分割线
        if configuration.showsSeparators == true {
            actionButtonStackView?.spacing = 0.5
            actionButtonStackView!.backgroundColor = configuration.separatorColor
            separatorView = UIView()
            separatorView?.backgroundColor = configuration.separatorColor
            separatorView?.translatesAutoresizingMaskIntoConstraints = false
            actionButtonContainerView?.addSubview(separatorView!)
        }
    }
    
    private init() {
        super.init(frame: CGRect.zero)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
//        backgroundContainerView?.backgroundColor = UIColor.white
//        titleLabel?.backgroundColor = UIColor.gray
//        messageTextView?.backgroundColor = UIColor.gray
//        contentViewContainerView?.backgroundColor = UIColor.gray
//        textFieldContainerView.backgroundColor = UIColor.gray
//        actionButtonContainerView.backgroundColor = UIColor.gray
//        actionButtonContainerView.backgroundColor = UIColor.gray
//        actionButtonStackView.backgroundColor = UIColor.green
//        separatorView?.backgroundColor = UIColor.gray

        // 添加约束
        self.snp.makeConstraints { (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.centerY.equalToSuperview().offset(0)
            constraintMaker.width.equalTo(UIScreen.main.bounds.width)
            constraintMaker.height.equalToSuperview()
        }
        
        backgroundContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.width.equalTo(maximumWidth!)
            constraintMaker.centerY.equalToSuperview()
            constraintMaker.height.greaterThanOrEqualTo(15+20+15)
        }

        titleLabel?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalToSuperview().offset(15)
            constraintMaker.height.greaterThanOrEqualTo(0)
        }

        messageTextView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.right.equalToSuperview()
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.top.equalTo(titleLabel!.snp_bottom).offset(15)
            constraintMaker.height.greaterThanOrEqualTo(20)
        }

        contentViewContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalTo(messageTextView!.snp_bottom).offset(0)
            constraintMaker.height.greaterThanOrEqualTo(0)
        }

        textFieldContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview().offset(15)
            constraintMaker.right.equalToSuperview().offset(-15)
            constraintMaker.top.equalTo(contentViewContainerView!.snp_bottom).offset(0)
            constraintMaker.height.greaterThanOrEqualTo(0)
        }

        actionButtonContainerView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.top.equalTo(textFieldContainerView!.snp_bottom).offset(15)
            constraintMaker.height.greaterThanOrEqualTo(40)
            constraintMaker.bottom.equalToSuperview()
        }

        actionButtonStackView?.snp.makeConstraints { (constraintMaker) in
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
