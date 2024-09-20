//
//  Configurator.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol Configurator {
    associatedtype ViewController: UIViewController
    func configure(_ viewController: ViewController)
}
