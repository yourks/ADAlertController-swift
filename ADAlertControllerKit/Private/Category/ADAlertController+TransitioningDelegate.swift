//
//  ADAlertController+TransitioningDelegate.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/5.
//

import UIKit

@objc extension ADAlertController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController: ADAlertControllerPresentationController = ADAlertControllerPresentationController(presentedViewController: presented, presenting: presenting)
        
        presentationController.hidenWhenTapBackground = self.configuration?.hidenWhenTapBackground
        
        presentationController.backgroundColor = self.configuration?.alertMaskViewBackgroundColor
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let style = self.configuration?.preferredStyle else { return nil }
        switch style {
        case .alert:
            return AlertViewStyleTransition(.presenting)
        case .actionSheet, .sheet:
            return ActionSheetStyleTransition(.presenting)
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let style = self.configuration?.preferredStyle else { return nil }
        switch style {
        case .alert:
            return AlertViewStyleTransition(.dismissing)
        case .actionSheet, .sheet:
            return ActionSheetStyleTransition(.dismissing)
        }
    }
}
