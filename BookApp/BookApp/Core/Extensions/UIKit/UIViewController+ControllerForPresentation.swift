//
//  UIViewController+ControllerForPresentation.swift
//  CHIReviewer
//
//  Created by Андрей on 06.04.2023.
//

import UIKit

extension UIViewController {
    var controllerForPresentation: UIViewController {
        var controllerToPresent: UIViewController = self
        var currentController = presentedViewController
        while currentController != nil {
            if let currentController = currentController, currentController.presentedViewController == nil {
                controllerToPresent = currentController
                break
            } else {
                currentController = currentController?.presentedViewController
            }
        }
        return controllerToPresent
    }
}
