//
//  ADAlertControllerPresentationController.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertControllerPresentationController: UIPresentationController {
    
    // MARK: - propert/public
    
    // 点击背景是否关闭警告框视图,默认 NO
    public var hidenWhenTapBackground: Bool?

    // 背景色
    public var backgroundColor: UIColor?

    // 背景视图
    public var backgroundView: UIView?

    // MARK: - propert/override
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }

    // MARK: - func/override
    override func presentationTransitionWillBegin() {
        
        if self.backgroundView == nil {
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = self.backgroundColor
            let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(tapGestureRecognized:)))
            self.backgroundView?.addGestureRecognizer(tapGestureRecognizer)
        }

        self.backgroundView?.alpha = 0.0
        self.containerView?.addSubview(self.backgroundView!)
        self.backgroundView?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        })
        
        let transitionCoordinator: UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        transitionCoordinator.animate { (_) in
            self.backgroundView?.alpha = 1
        } completion: { (_) in
                
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.backgroundView?.frame = self.containerView!.bounds
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed == false {
            self.backgroundView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let transitionCoordinator: UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        transitionCoordinator.animate { (_) in
            self.backgroundView?.alpha = 0.0
            self.presentingViewController.view.transform = CGAffineTransform.identity
        } completion: { (_) in
                
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed == false {
            self.backgroundView?.removeFromSuperview()
        }
    }
    
    // MARK: - @objc func
    @objc func tapGestureRecognized(tapGestureRecognized: UITapGestureRecognizer) {
        if self.hidenWhenTapBackground == true {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}
