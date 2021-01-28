//
//  Animator.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/28.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 3
    private var firstViewController: AnimationViewController
    private var secondViewController: DestinationViewController
    private var isPresenting: Bool
    
    init?(from firstViewController: AnimationViewController, to secondViewController: DestinationViewController, isPresenting: Bool) {
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = secondViewController.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
    
    
}
