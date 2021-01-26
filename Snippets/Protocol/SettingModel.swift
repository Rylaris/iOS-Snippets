//
//  SettingModel.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/21.
//

import UIKit

protocol SettingModel {
    var leftImage: UIImage? { get set }
    var text: String? { get set }
    var detailText: String? { get set }
    var accessoryType: UITableViewCell.AccessoryType { get set }

    func trigger()
}

struct NavigationCell: SettingModel {
    enum NavigatorStyle {
        case push
        case present
        case presentWithFullScreen
    }
    
    var style: NavigatorStyle
    var viewController: UIViewController.Type
    
    var leftImage: UIImage?
    var text: String?
    var detailText: String?
    var accessoryType: UITableViewCell.AccessoryType
    
    init(viewController: UIViewController.Type, style: NavigatorStyle, leftImage: UIImage? = nil, text: String? = nil, detailText: String? = nil, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.viewController = viewController
        self.style = style
        self.leftImage = leftImage
        self.text = text
        self.detailText = detailText
        self.accessoryType = accessoryType
    }
    
    func trigger() {
        switch style {
        case .present:
            UIViewController.getCurrentViewController()?.present(viewController.init(), animated: true, completion: nil)
        case .presentWithFullScreen:
            let navigationController = UINavigationController(rootViewController: viewController.init())
            navigationController.modalPresentationStyle = .fullScreen
            UIViewController.getCurrentViewController()?.present(navigationController, animated: true, completion: nil)
        case .push:
            UIViewController.getCurrentViewController()?.navigationController?.pushViewController(viewController.init(), animated: true)
        }
    }
}

struct ActionCell: SettingModel {
    var action: () -> Void
    
    var leftImage: UIImage?
    var text: String?
    var detailText: String?
    var accessoryType: UITableViewCell.AccessoryType
    
    init(leftImage: UIImage? = nil, text: String? = nil, detailText: String? = nil, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator, action: @escaping (() -> Void)) {
        self.action = action
        self.leftImage = leftImage
        self.text = text
        self.detailText = detailText
        self.accessoryType = accessoryType
    }
    
    func trigger() {
        action()
    }
}

struct SwitchCell: SettingModel {
    var uiSwitch = UISwitch()
    
    var leftImage: UIImage?
    var text: String?
    var detailText: String?
    var accessoryType: UITableViewCell.AccessoryType
    
    init(leftImage: UIImage? = nil, text: String? = nil, detailText: String? = nil, target: Any? = nil, action: Selector? = nil, status: UIControl.Event = .touchUpInside, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.leftImage = leftImage
        self.text = text
        self.detailText = detailText
        if let action = action {
            uiSwitch.addTarget(target, action: action, for: status)
        }
        self.accessoryType = accessoryType
    }
    
    func trigger() {}
}
