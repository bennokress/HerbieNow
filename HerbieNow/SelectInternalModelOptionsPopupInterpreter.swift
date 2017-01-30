//
//  SelectInternalModelOptionsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectInternalModelOptionsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?)

}

// MARK: -
class SelectInternalModelOptionsPopupInterpreter {
    
    // MARK: Links

    var presenter: SelectInternalModelOptionsPopupPresenterProtocol
    var logic: LogicProtocol
    
    // MARK: Initialization

    init(for vehicleMapVC: SelectInternalModelOptionsPopupViewControllerProtocol? = nil, _ presenter: SelectInternalModelOptionsPopupPresenterProtocol = SelectInternalModelOptionsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectInternalModelOptionsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

// MARK: Select Internal Model Options Popup Interpreter Protocol Conformance
extension SelectInternalModelOptionsPopupInterpreter: SelectInternalModelOptionsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .internalModelOptionsPopupData(let filterset) = viewData {
            // TODO: Retrieve Data from ViewData
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }

}
