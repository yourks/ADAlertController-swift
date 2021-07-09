//
//  ADAlertControllerPresentationController.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/2.
//

import UIKit

class ADAlertControllerPresentationController: UIPresentationController {
    
    //MARK: - propert/public
    
    //点击背景是否关闭警告框视图,默认 NO
    public var hidenWhenTapBackground :Bool?

    //背景色
    public var backgroundColor :UIColor?

    //背景视图
    public var backgroundView :UIView?

    //MARK: - propert/override
    override var shouldPresentInFullscreen: Bool{
        get{
            return false
        }
    }
    
    override var shouldRemovePresentersView: Bool{
        get{
            return false
        }
    }

    //MARK: - func/override
    override func presentationTransitionWillBegin() {
        
        if self.backgroundView == nil {
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = self.backgroundColor
            let tapGestureRecognizer :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(tapGestureRecognized:)))
            self.backgroundView?.addGestureRecognizer(tapGestureRecognizer)
        }

        self.backgroundView?.alpha = 0.0;
        self.containerView?.addSubview(self.backgroundView!)
        self.backgroundView?.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.edges.equalToSuperview()
        })
        
        let transitionCoordinator :UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        transitionCoordinator.animate { (UIViewControllerTransitionCoordinatorContext) in
            self.backgroundView?.alpha = 1;
        } completion: { (UIViewControllerTransitionCoordinatorContext) in
                
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.backgroundView?.frame = self.containerView!.bounds
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if (completed == false) {
            self.backgroundView?.removeFromSuperview();
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let transitionCoordinator :UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        transitionCoordinator.animate { (UIViewControllerTransitionCoordinatorContext) in
            self.backgroundView?.alpha = 0.0;
            self.presentingViewController.view.transform = CGAffineTransform.identity;
        } completion: { (UIViewControllerTransitionCoordinatorContext) in
                
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if (completed == false) {
            self.backgroundView?.removeFromSuperview();
        }
    }
    
    //MARK: - @objc func
    @objc func tapGestureRecognized(tapGestureRecognized :UITapGestureRecognizer) -> Void {
        if self.hidenWhenTapBackground == true {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}
