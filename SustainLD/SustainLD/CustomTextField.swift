//
//  CustomTextField.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/11/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
