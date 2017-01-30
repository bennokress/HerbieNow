//
//  SelectFiltersetIconAndNamePopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectFiltersetIconAndNamePopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?)

}

class SelectFiltersetIconAndNamePopupInterpreter {

    var presenter: SelectFiltersetIconAndNamePopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil, _ presenter: SelectFiltersetIconAndNamePopupPresenterProtocol = SelectFiltersetIconAndNamePopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectFiltersetIconAndNamePopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectFiltersetIconAndNamePopupInterpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol {

    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .filtersetNameAndIconPopupData() = viewData {
            // TODO: get data by adding .filtersetNameAndIconPopupData(let xyz) above
            // TODO: pass to presenter
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }
    
}
