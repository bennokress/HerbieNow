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
    
    func iconSelected(_ encodedIcon: String, with data: ViewData?)
    func filtersetNameChanged(to newName: String, with data: ViewData?)

}

// MARK: -
class SelectFiltersetIconAndNamePopupInterpreter {
    
    // MARK: Links

    var presenter: SelectFiltersetIconAndNamePopupPresenterProtocol
    var logic: LogicProtocol

    // MARK: Initialization
    
    init(for vehicleMapVC: SelectFiltersetIconAndNamePopupViewControllerProtocol? = nil, _ presenter: SelectFiltersetIconAndNamePopupPresenterProtocol = SelectFiltersetIconAndNamePopupPresenter(to: nil), _ logic: LogicProtocol = Logic()) {

        self.presenter = SelectFiltersetIconAndNamePopupPresenter(to: vehicleMapVC)
        self.logic = Logic()

    }

}

// MARK: Select Filterset Icon and Name Popup Interpreter Protocol Conformance
extension SelectFiltersetIconAndNamePopupInterpreter: SelectFiltersetIconAndNamePopupInterpreterProtocol {

    func viewDidAppear(with data: ViewData?) {
        guard let viewData = data else {
            Debug.print(.error(source: .location(Source()), message: "No data found."))
            return
        }
        
        if case .filtersetNameAndIconPopupData(let filterset, let icons) = viewData {
            if let icons = icons { presenter.fillPicker(with: icons) }
            presenter.updateAllElements(for: filterset)
            filterset.debugPrint()
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }
    
    func iconSelected(_ encodedIcon: String, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        displayedFilterset.update(image: encodedIcon)
        presenter.updateAllElements(for: displayedFilterset)
    }
    
    func filtersetNameChanged(to newName: String, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        displayedFilterset.update(name: newName)
        presenter.updateAllElements(for: displayedFilterset)
    }
    
}
