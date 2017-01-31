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
    
    // MARK: UI Interaction
    func fuelTypeButtonTapped(for changedFuelType: FuelType, with data: ViewData?)
    func transmissionTypeButtonTapped(for changedTransmissionType: TransmissionType, with data: ViewData?)
    func hifiSystemOnlyButtonTapped(with data: ViewData?)

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
            presenter.updateAllElements(for: filterset)
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }
    
    // MARK: UI Interaction
    
    func fuelTypeButtonTapped(for changedFuelType: FuelType, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .fuelType(let petrolSelection, let dieselSelection, let electricSelection) = displayedFilterset.fuelTypeFilter {
            let newFilter: Filter
            
            switch changedFuelType {
            case .diesel:
                newFilter = .fuelType(petrol: petrolSelection, diesel: dieselSelection.flipped, electric: electricSelection)
            case .petrol:
                newFilter = .fuelType(petrol: petrolSelection.flipped, diesel: dieselSelection, electric: electricSelection)
            case .electric:
                newFilter = .fuelType(petrol: petrolSelection, diesel: dieselSelection, electric: electricSelection.flipped)
            case .unknown:
                newFilter = .fuelType(petrol: petrolSelection, diesel: dieselSelection, electric: electricSelection)
            }
            
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }
    
    func transmissionTypeButtonTapped(for changedTransmissionType: TransmissionType, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .transmission(let automaticSelection, let manualSelection) = displayedFilterset.transmissionFilter {
            let newFilter: Filter
            
            switch changedTransmissionType {
            case .automatic:
                newFilter = .transmission(automatic: automaticSelection.flipped, manual: manualSelection)
            case .manual:
                newFilter = .transmission(automatic: automaticSelection, manual: manualSelection.flipped)
            case .unknown:
                newFilter = .transmission(automatic: automaticSelection, manual: manualSelection)
            }
            
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }
    
    func hifiSystemOnlyButtonTapped(with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .hifiSystem(let previousChoice) = displayedFilterset.hiFiSystemFilter {
            let newFilter: Filter = .hifiSystem(only: previousChoice.flipped)
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }

}
