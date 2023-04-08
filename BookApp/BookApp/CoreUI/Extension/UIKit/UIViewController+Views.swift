//
//  UIViewController+Views.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import UIKit

extension UIViewController {
    func addBackButton() {
        let buttonLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "chevron.left")
        buttonLeftMenu.setImage(image, for: .normal)
        buttonLeftMenu.sizeToFit()
        buttonLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc
    func backButtonClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
