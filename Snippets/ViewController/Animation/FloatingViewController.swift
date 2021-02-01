//
//  FloatingViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/2/1.
//

import UIKit

class FloatingViewController: UIViewController {
    
    lazy var mainView = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "浮窗操作"
        
        view.addSubview(mainView)
        let width = view.frame.width / 3
        let height = view.frame.height / 4
        mainView.frame = CGRect(x: view.frame.width - width - 10, y: view.frame.height - height - 10, width: width, height: height)
        mainView.layer.cornerRadius = 15
        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOffset = .zero
        mainView.backgroundColor = .systemBlue
        mainView.setTitle("拖我拖我", for: .normal)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(sender:)))
        dragGesture.maximumNumberOfTouches = 1
        mainView.addGestureRecognizer(dragGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        mainView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: view)
        let newX = mainView.center.x + point.x
        // 防止越出左右边界
        if newX + mainView.frame.width / 2 < view.frame.width &&
            newX - mainView.frame.width / 2 > 0 {
            mainView.center = CGPoint(x: newX, y: mainView.center.y)
        }
        // 防止越出上下边界
        let newY = mainView.center.y + point.y
        if newY + mainView.frame.height / 2 < view.frame.height &&
            newY - mainView.frame.height / 2 > 0 {
            mainView.center = CGPoint(x: mainView.center.x, y: newY)
        }
        sender.setTranslation(.zero, in: view)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let center = mainView.center
        let newSize = CGSize(width: mainView.frame.width * scale, height: mainView.frame.height * scale)
        if newSize.width < view.frame.width && newSize.height < view.frame.height {
            mainView.frame.size = newSize
        }
        mainView.center = center
        if mainView.frame.maxX > view.bounds.maxX {
            mainView.center = CGPoint(x: view.frame.width - mainView.frame.width / 2, y: mainView.center.y)
        }
        if mainView.frame.maxY > view.bounds.maxY {
            mainView.center = CGPoint(x: mainView.center.x, y: view.frame.height - mainView.frame.height / 2)
        }
        if mainView.frame.minX < 0 {
            mainView.center = CGPoint(x: 0 + mainView.frame.width / 2, y: mainView.center.y)
        }
        if mainView.frame.minY < 0 {
            mainView.center = CGPoint(x: mainView.center.x, y: 0 + mainView.frame.height / 2)
        }
        sender.scale = 1
    }
}
