//
//  Factory.swift
//  CHIReviewer
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

typealias Factory = CoordinatorFactory & ViewControllerFactory
typealias ViewControllerFactory = LauncViewControllerFactory & LibraryFactory
