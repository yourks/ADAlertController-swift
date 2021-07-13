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
        
        if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleAlert {
            
            let transition: ADAlertViewAlertStyleTransition = ADAlertViewAlertStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStylePresenting
            
            return transition
        } else if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleSheet {
            
            let transition: ADAlertViewSheetStyleTransition = ADAlertViewSheetStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStylePresenting
            
            return transition
        } else
//        if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleSheet
        {
            let transition: ADAlertViewSheetStyleTransition = ADAlertViewSheetStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStylePresenting
            
            return transition
        }
        
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleAlert {
            
            let transition: ADAlertViewAlertStyleTransition = ADAlertViewAlertStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStyleDismissing
            
            return transition
        } else if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleSheet {
            
            let transition: ADAlertViewSheetStyleTransition = ADAlertViewSheetStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStyleDismissing
            
            return transition
        } else
//        if self.configuration!.preferredStyle == ADAlertControllerStyle.ADAlertControllerStyleSheet
        {
            let transition: ADAlertViewSheetStyleTransition = ADAlertViewSheetStyleTransition()
            
            transition.transitionStyle = ADAlertTransitionStyle.ADAlertTransitionStyleDismissing
            
            return transition
        }
    }
}
