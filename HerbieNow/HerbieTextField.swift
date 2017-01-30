//
//  HerbieTextField.swift
//  HerbieNow
//
//  Created by Vivien Bardosi on 26.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

class HerbieTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(hexString: "90a6c1")?.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)

        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

        setPlaceHolderTextColor(UIColor(cgColor: border.borderColor!))
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
