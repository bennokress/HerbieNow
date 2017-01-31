//
//  SelectExternalModelOptionsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectExternalModelOptionsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?)

}

// MARK: -
class SelectExternalModelOptionsPopupInterpreter {
    
    // MARK: Links

    var presenter: SelectExternalModelOptionsPopupPresenterProtocol
    var logic: LogicProtocol
    
    // MARK: Initialization

    init(for vehicleMapVC: SelectExternalModelOptionsPopupViewControllerProtocol? = nil, _ presenter: SelectExternalModelOptionsPopupPresenterProtocol = SelectExternalModelOptionsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectExternalModelOptionsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

// MARK: Select External Model Options Popup Interpreter Protocol Conformance
extension SelectExternalModelOptionsPopupInterpreter: SelectExternalModelOptionsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .externalModelOptionsPopupData(let filterset) = viewData {
            // TODO: Retrieve Data from ViewData
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }

}
