//
//  ADAlertTextView.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertTextView: UITextView {

    //Mark：- proprety/private
    private var heightConstraint :NSLayoutConstraint?
    
    //Mark：- func/init
    internal override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        heightConstraint = self.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint?.priority = UILayoutPriority.defaultHigh
        heightConstraint?.isActive = true
        self.textContainerInset = UIEdgeInsets.zero;
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var text: String! {
        didSet{
            self.updateHeightConstraint()
        }
    }

    override var bounds: CGRect {
        willSet{
            
            let oldBounds :CGRect  = self.bounds;

            super.bounds = newValue

            if oldBounds.width == newValue.width , oldBounds.height == newValue.height  {
            }else{
                self.updateHeightConstraint()
            }
        }
    }

    //Mark：- func/private
    private func updateHeightConstraint() -> Void {
        if text.count > 0 {
            self.heightConstraint!.constant = self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            
            if self.heightConstraint!.constant > 300 {
                self.heightConstraint!.constant = 300
                self.isUserInteractionEnabled = true
            }

        }else{
            heightConstraint?.constant = 0
            self.textContainerInset = UIEdgeInsets.zero;

        }
    }
    
}
