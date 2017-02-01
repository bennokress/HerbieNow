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
    
    // MARK: UI Interaction
    func seatsButtonTapped(for seatSelection: Int, with data: ViewData?)
    func doorsButtonTapped(for doorSelection: Int, with data: ViewData?)
    func horsePowerSliderChanged(min: Double, max: Double, with data: ViewData?)
    func fuelLevelSliderChanged(min: Double, max: Double, with data: ViewData?)

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
    
    func seatsButtonTapped(for seatSelection: Int, with data: ViewData?) {
        Debug.print(.info(source: .location(Source()), message: "\(seatSelection) Seats tapped."))
    }
    
    func doorsButtonTapped(for doorSelection: Int, with data: ViewData?) {
        Debug.print(.info(source: .location(Source()), message: "\(doorSelection) Doors tapped."))
    }
    
    func horsePowerSliderChanged(min: Double, max: Double, with data: ViewData?) {
        Debug.print(.info(source: .location(Source()), message: "\(min) - \(max) Horse Power selected."))
    }
    
    func fuelLevelSliderChanged(min: Double, max: Double, with data: ViewData?) {
        Debug.print(.info(source: .location(Source()), message: "\(min) - \(max) Fuel Level selected."))
    }

}
