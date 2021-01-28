//
//  CoreAnimationCombineCoreGraphicsViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/28.
//

import UIKit
import CoreGraphics

class CoreAnimationAndCoreGraphicsViewController: UIViewController {
    
    lazy var cgView = CoreGraphicsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "蓝色CA红色CG"
        
        view.backgroundColor = .white
        
        cgView = CoreGraphicsView(frame: view.frame)
        view.addSubview(cgView)
        drawWithCoreAnimation()
    }
    
    func drawWithCoreAnimation() {
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: 150, y: 225), radius: 25, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        path.move(to: .init(x: 50, y: 200))
        path.addLine(to: .init(x: 100, y: 200))
        path.addLine(to: .init(x: 100, y: 250))
        path.addLine(to: .init(x: 50, y: 250))
        path.addLine(to: .init(x: 50, y: 200))
        
        
        path.move(to: .init(x: 200, y: 250))
        path.addLine(to: .init(x: 250, y: 250))
        path.addLine(to: .init(x: 225, y: 200))
        path.addLine(to: .init(x: 200, y: 250))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.systemBlue.cgColor
        
        
        view.layer.addSublayer(shapeLayer)
    }
    
}

class CoreGraphicsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        let path = CGMutablePath()
        path.addArc(center: .init(x: 150, y: 325), radius: 25, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.addRect(.init(x: 50, y: 300, width: 50, height: 50))
        path.addLines(between: [CGPoint(x: 250, y: 350), CGPoint(x: 225, y: 300), CGPoint(x: 200, y: 350)])
        context?.addPath(path)
        context?.setFillColor(UIColor.systemRed.cgColor)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1)
        context?.drawPath(using: .fillStroke)
    }
}
