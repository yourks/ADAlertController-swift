//
//  AlertViewStyleTransition.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit
/**
 1.并不是所有类,都需要继承自NSObject,只有需要跟objc交互时,或者用到objc的相关方法,
 比如这里UIViewControllerAnimatedTransitioning协议就要求是NSObject的子类才能遵循
 2.对于不变的变量,可以考虑用let,并增加初始化方法
 3.模块可不用添加前缀,swift里有命名空间,加入两个模块都命名了相同的名字,用模块名加前缀即可解决冲突
 4.访问权限默认是internal,可以不写
 
 */


class AlertViewStyleTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - propert/public
    let transitionStyle: ADAlertTransitionStyle // ⚠️:如果该类并不打算暴露,这里的属性用public也没意义,外部一样访问不了

    init(_ transitionStyle: ADAlertTransitionStyle) {
        self.transitionStyle = transitionStyle
    }
    
    // MARK: - func/internal
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return viewControllerTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if transitionStyle == .presenting {
            
            self.doPresentingAnimation(using: transitionContext)
                
        } else {
            
            self.doDismissingAnimation(using: transitionContext)
            
        }
    }
    
    private func doPresentingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
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

    private func doDismissingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
                
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!

        if let fromVC = fromViewController as? AlertStyleTransitionBehaviorProtocol {
            if fromVC.moveoutScreen {
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
