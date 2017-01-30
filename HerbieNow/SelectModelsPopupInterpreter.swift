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

/// The Interpreter is only called by a ViewController and decides what method of the Model has to be run. Gets data back via closures.
class SelectModelsPopupInterpreter {

    var presenter: SelectModelsPopupPresenterProtocol
    var logic: LogicProtocol

    init(for vehicleMapVC: SelectModelsPopupViewControllerProtocol? = nil, _ presenter: SelectModelsPopupPresenterProtocol = SelectModelsPopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectModelsPopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

extension SelectModelsPopupInterpreter: SelectModelsPopupInterpreterProtocol {
    
    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .modelsPopupData() = viewData {
            // TODO: get data by adding .filtersetNameAndIconPopupData(let xyz) above
            // TODO: pass to presenter
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }

}
