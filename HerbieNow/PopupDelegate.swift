//
//  PopupDelegate.swift
//  HerbieNow
//
//  Created by Benno Kress on 18.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol PopupDelegate {

    func popupDismissed(with selectedData: ViewReturnData, via navigationAction: NavigationAction)
    func popupWorkflowAborted()

    func showLoadingAnimation(title: String)
    func dismissLoadingAnimation()

}
