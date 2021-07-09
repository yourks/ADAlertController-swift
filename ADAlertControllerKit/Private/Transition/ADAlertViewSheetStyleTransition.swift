//
//  ADAlertViewSheetStyleTransition.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertViewSheetStyleTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    // MARK: - propert/public
    public var transitionStyle: ADAlertControllerTransitionStyle?

    // MARK: - func/internal
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kADAlertControllerTransitionDuration;
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if transitionStyle == ADAlertControllerTransitionStyle.ADAlertControllerTransitionStylePresenting {
            
            let toViewController :UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            
            transitionContext.containerView.addSubview(toViewController.view)
            
            if let VC = toViewController as? ADAlertController{
                if let view = VC.mainView {
                    
                    let contentHeight :CGFloat = view.backgroundContainerView?.systemLayoutSizeFitting(CGSize.zero, withHorizontalFittingPriority: UILayoutPriority.defaultHigh, verticalFittingPriority: UILayoutPriority.defaultHigh).height ?? 0
                    
                    toViewController.view.transform = CGAffineTransform.init(translationX: 0, y: contentHeight);
                    
                    UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
                        toViewController.view.transform = CGAffineTransform.identity;
                    }completion: { (Bool) in
                        transitionContext.completeTransition(true)
                    }
                    
                }
            }
            
        }else{
            
            let fromViewController :UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            
            fromViewController.view.transform = CGAffineTransform.identity
            
            if let VC = fromViewController as? ADAlertController{
                if let view = VC.mainView {

                    let contentHeight :CGFloat = view.backgroundContainerView?.systemLayoutSizeFitting(CGSize.zero, withHorizontalFittingPriority: UILayoutPriority.defaultHigh, verticalFittingPriority: UILayoutPriority.defaultHigh).height ?? 0
                    
                    UIView.animate(withDuration: 0.3) {
                        fromViewController.view.transform = CGAffineTransform.init(translationX: 0, y: contentHeight)
                    }completion: { (Bool) in
                        fromViewController.view.removeFromSuperview()
                        fromViewController.view.transform = CGAffineTransform.identity;
                        transitionContext.completeTransition(true)
                    }
                    
                }
            }
        }
    }
}
