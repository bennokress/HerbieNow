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
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .seats(let twoSelection, let fourSelection, let fiveSelection) = displayedFilterset.seatsFilter {
            let newFilter: Filter
            
            switch seatSelection {
            case 2:
                newFilter = .seats(two: twoSelection.flipped, four: fourSelection, five: fiveSelection)
            case 4:
                newFilter = .seats(two: twoSelection, four: fourSelection.flipped, five: fiveSelection)
            case 5:
                newFilter = .seats(two: twoSelection, four: fourSelection, five: fiveSelection.flipped)
            default:
                newFilter = .seats(two: twoSelection, four: fourSelection, five: fiveSelection)
            }
            
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }
    
    func doorsButtonTapped(for doorSelection: Int, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .doors(let threeSelection, let fiveSelection) = displayedFilterset.doorsFilter {
            let newFilter: Filter
            
            switch doorSelection {
            case 3:
                newFilter = .doors(three: threeSelection.flipped, five: fiveSelection)
            case 5:
                newFilter = .doors(three: threeSelection, five: fiveSelection.flipped)
            default:
                newFilter = .doors(three: threeSelection, five: fiveSelection)
            }
            
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }
    
    func horsePowerSliderChanged(min: Double, max: Double, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        let minSelection = Int(min)
        let maxSelection = Int(max)
        let newFilter = Filter.hp(min: minSelection, max: maxSelection)
        displayedFilterset.update(filter: newFilter)
        presenter.updateAllElements(for: displayedFilterset)
    }
    
    func fuelLevelSliderChanged(min: Double, max: Double, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        let minSelection = Int(min)
        let maxSelection = Int(max)
        let newFilter = Filter.fuelLevel(min: minSelection, max: maxSelection)
        displayedFilterset.update(filter: newFilter)
        presenter.updateAllElements(for: displayedFilterset)
    }

}
