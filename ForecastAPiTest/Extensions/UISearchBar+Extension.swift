//
//  UISearchBar+Extension.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//


import UIKit

extension UISearchBar {
    func setTextFieldColor(color: UIColor, textColor: UIColor) {
        self.searchTextField.backgroundColor = color
        self.searchTextField.textColor = textColor
        self.searchTextField.tintColor = .darkGray
    }
}
