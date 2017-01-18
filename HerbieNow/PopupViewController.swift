//
//  PopupViewController.swift
//  it-e TimeTrack
//
//  Created by Benno Kress on 18.01.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import Presentr

class PopupViewController: UIViewController {
    
    // General Filterset without limitations to manipulate by user over the popup-workflow - Attention: Position is -1 and has to be set by the icon that was tapped!
    var filterset: Filterset = Filterset(from: "11:1111:11111111111111111:111:11:000999:000100:11:111:0:-1:New Filter:No Image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension PopupViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print(Debug.warning(source: (name(of: self), #function), message: "Popup was dismissed without saving."))
        return true
    }
    
}
