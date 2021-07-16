//
//  ActionSheetStyleTransition.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ActionSheetStyleTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - propert/public
    let transitionStyle: ADAlertTransitionStyle

    init(_ transitionStyle: ADAlertTransitionStyle) {
        self.transitionStyle = transitionStyle
    }
    
    
    // MARK: - func/internal
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return viewControllerTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if transitionStyle == .presenting {
            
            let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            
            transitionContext.containerView.addSubview(toViewController.view)
            
            if let viewController = toViewController as? ADAlertController {
                if let view = viewController.mainView {
                    
                    let contentHeight: CGFloat = view.backgroundContainerView?.systemLayoutSizeFitting(CGSize.zero, withHorizontalFittingPriority: UILayoutPriority.defaultHigh, verticalFittingPriority: UILayoutPriority.defaultHigh).height ?? 0
                    
                    toViewController.view.transform = CGAffineTransform.init(translationX: 0, y: contentHeight)
                    
                    UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
                        toViewController.view.transform = CGAffineTransform.identity
                    }completion: { (_) in
                        transitionContext.completeTransition(true)
                    }
                    
                }
            }
            
        } else {
            
            let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            
            fromViewController.view.transform = CGAffineTransform.identity
            
            if let viewController = fromViewController as? ADAlertController {
                if let view = viewController.mainView {

                    let contentHeight: CGFloat = view.backgroundContainerView?.systemLayoutSizeFitting(CGSize.zero, withHorizontalFittingPriority: UILayoutPriority.defaultHigh, verticalFittingPriority: UILayoutPriority.defaultHigh).height ?? 0
                    
                    UIView.animate(withDuration: 0.3) {
                        fromViewController.view.transform = CGAffineTransform.init(translationX: 0, y: contentHeight)
                    }completion: { (_) in
                        fromViewController.view.removeFromSuperview()
                        fromViewController.view.transform = CGAffineTransform.identity
                        transitionContext.completeTransition(true)
                    }
                    
                }
            }
        }
    }
}
