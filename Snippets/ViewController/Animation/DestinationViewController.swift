//
//  DestinationViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/28.
//

import UIKit

class DestinationViewController: UIViewController {
    
    lazy var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}
