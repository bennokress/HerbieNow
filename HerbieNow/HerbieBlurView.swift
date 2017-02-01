//
//  HerbieBlurView.swift
//  HerbieNow
//
//  Created by Vivien Bardosi on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

class HerbieBlurView: UIVisualEffectView {
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
