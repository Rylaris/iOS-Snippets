//
//  AnimationViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/28.
//

import UIKit

class AnimationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAnimation))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentAnimation() {
        let destination = DestinationViewController()
        destination.modalPresentationStyle = .fullScreen
        destination.transitioningDelegate = self
        present(destination, animated: true, completion: nil)
    }
}

extension AnimationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let first = source as? AnimationViewController, let second = presented as? DestinationViewController else {
            return nil
        }
        return Animator(from: first, to: second, isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let second = dismissed as? DestinationViewController else {
            return nil
        }
        return Animator(from: self, to: second, isPresenting: false)
    }
}
