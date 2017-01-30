//
//  SelectModelsPopupInterpreter.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol SelectModelsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?)

}

// MARK: -
class SelectModelsPopupInterpreter {
    
    // MARK: Links

    var presenter: SelectModelsPopupPresenterProtocol
    var logic: LogicProtocol
    
    // MARK: Initialization

    init(for vehicleMapVC: SelectModelsPopupViewControllerProtocol? = nil, _ presenter: SelectModelsPopupPresenterProtocol = SelectModelsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectModelsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

// MARK: Select Models Popup Interpreter Protocol Conformance
extension SelectModelsPopupInterpreter: SelectModelsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .modelsPopupData(let filterset, let displayedModels) = viewData {
            // TODO: Retrieve Data from ViewData
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }

}
