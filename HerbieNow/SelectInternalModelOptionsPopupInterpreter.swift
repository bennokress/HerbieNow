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

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectInternalModelOptionsPopupInterpreter {

    var presenter: SelectInternalModelOptionsPopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectInternalModelOptionsPopupViewControllerProtocol? = nil, _ presenter: SelectInternalModelOptionsPopupPresenterProtocol = SelectInternalModelOptionsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectInternalModelOptionsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectInternalModelOptionsPopupInterpreter: SelectInternalModelOptionsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .internalModelOptionsPopupData() = viewData {
            // TODO: implement
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }

}
