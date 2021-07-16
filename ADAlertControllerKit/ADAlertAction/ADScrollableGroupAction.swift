//
//  ADScrollableGroupAction.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADScrollableGroupAction: ADAlertGroupAction {

    
    // MARK: - proprety/private
    
    // actionWidth
    private var actionWidth: CGFloat?

    // MARK: - func init
    
    required override init() {
        super.init()
    }

    static func scrollActionWithActions(actions: [ADAlertAction]) -> ADScrollableGroupAction? {
        
        let action: ADScrollableGroupAction = ADScrollableGroupAction()
        
        action.actionWidth = 50+30

        action.actions = actions

        return action
    }
    
    
    override func loadView() -> UIView {
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.showsHorizontalScrollIndicator = NO;

        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        

        let scroll: UIScrollView = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
            constraintMaker.height.equalToSuperview()
        })
        scroll.backgroundColor = UIColor.clear
        scroll.bounces = false

        self.actionButtonStackView = UIStackView()
        self.actionButtonStackView?.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        self.actionButtonStackView?.spacing = 30.0
        
        let width: CGFloat = CGFloat(self.actions!.count) * actionWidth!
        scroll.addSubview(self.actionButtonStackView!)
        self.actionButtonStackView?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.left.top.bottom.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.width.equalTo(width)
            constraintMaker.height.equalToSuperview()
        })
        self.actionButtonStackView?.backgroundColor = UIColor.clear

        actionButtonStackView?.axis = NSLayoutConstraint.Axis.horizontal
        actionButtonStackView?.alignment = UIStackView.Alignment.fill
        actionButtonStackView?.distribution = UIStackView.Distribution.fillEqually
        self.actionButtonStackView?.layoutIfNeeded()

        for action: ADAlertAction in self.actions! {
            self.actionButtonStackView!.addArrangedSubview(action.loadView())
        }

        return view
    }
}
