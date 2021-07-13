//
//  ADAlertViewAlertStyleTransition.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertViewAlertStyleTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - propert/public
    public var transitionStyle: ADAlertTransitionStyle?

    
    // MARK: - func/internal
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kADAlertControllerTransitionDuration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if transitionStyle == ADAlertTransitionStyle.ADAlertTransitionStylePresenting {
            
            self.ADAlertTransitionStylePresentingAnimation(using: transitionContext)
                
        } else {
            
            self.ADAlertTransitionStyleDismissingAnimation(using: transitionContext)
            
        }
    }
    
    internal func ADAlertTransitionStylePresentingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        toViewController.view.layer.opacity = 0.5
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toViewController.view.layer.opacity = 1.0
        } completion: { (_) in}

        toViewController.view.layer.transform = CATransform3DIdentity
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeLinear) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                let scale: CGFloat = 1.13
                toViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                toViewController.view.layer.transform = CATransform3DIdentity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
                let scale: CGFloat = 0.87
                toViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                toViewController.view.layer.transform = CATransform3DIdentity
            }
            
        } completion: { (_) in
            transitionContext.completeTransition(true)
        }
    }

    internal func ADAlertTransitionStyleDismissingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
                
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!

        if let fromVC = fromViewController as? ADAlertViewAlertStyleTransitionProtocol {
            if fromVC.moveoutScreen == true {
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(true)
                return
            }
        }
        
        fromViewController.view.layer.transform = CATransform3DIdentity
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeLinear) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                let scale: CGFloat = 1.13
                fromViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                fromViewController.view.layer.transform = CATransform3DIdentity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
                let scale: CGFloat = 0.01
                fromViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
                fromViewController.view.layer.opacity = 0.4
            }
        } completion: { (_) in
            fromViewController.view.removeFromSuperview()
            fromViewController.view.layer.transform = CATransform3DIdentity
            fromViewController.view.layer.opacity = 1.0
            transitionContext.completeTransition(true)
        }
    }

}
