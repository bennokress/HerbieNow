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
    
    // MARK: UI Interaction
    func modelButtonTapped(for modelSelection: Model, with data: ViewData?)

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
        
        if case .modelsPopupData(var filterset, let displayedModels) = viewData {
            let mini3door = displayedModels.contains(Model.mini3Door)
            let mini5door = displayedModels.contains(Model.mini5Door)
            let miniConvertible = displayedModels.contains(Model.miniConvertible)
            let miniClubman = displayedModels.contains(Model.miniClubman)
            let miniCountryman = displayedModels.contains(Model.miniCountryman)
            let bmwI3 = displayedModels.contains(Model.bmwI3)
            let bmw1er = displayedModels.contains(Model.bmw1er3Door) || displayedModels.contains(Model.bmw1er3Door)
            let bmwX1 = displayedModels.contains(Model.bmwX1)
            let bmw2erAT = displayedModels.contains(Model.bmw2erAT)
            let bmw2erConvertible = displayedModels.contains(Model.bmw2erConvertible)
            let smartForTwo = displayedModels.contains(Model.smartForTwo)
            let smartRoadster = displayedModels.contains(Model.smartRoadster)
            let smartForFour = displayedModels.contains(Model.smartForFour)
            let mercedesGLA = displayedModels.contains(Model.mercedesGLA)
            let mercedesCLA = displayedModels.contains(Model.mercedesCLA)
            let mercedesA = displayedModels.contains(Model.mercedesAclass)
            let mercedesB = displayedModels.contains(Model.mercedesBclass)
            
            let modelFilter = Filter.model(mini3door: mini3door, mini5door: mini5door, miniConvertible: miniConvertible, miniClubman: miniClubman, miniCountryman: miniCountryman, bmwI3: bmwI3, bmw1er: bmw1er, bmwX1: bmwX1, bmw2erAT: bmw2erAT, bmw2erConvertible: bmw2erConvertible, smartForTwo: smartForTwo, smartRoadster: smartRoadster, smartForFour: smartForFour, mercedesGLA: mercedesGLA, mercedesCLA: mercedesCLA, mercedesA: mercedesA, mercedesB: mercedesB)
            
            filterset.update(filter: modelFilter)
            presenter.updateAllElements(for: filterset)
            filterset.debugPrint()
        } else {
            Debug.print(.error(source: .location(Source()), message: "Data is in wrong format."))
        }
    }
    
    func modelButtonTapped(for modelSelection: Model, with data: ViewData?) {
        guard let viewData = data, var displayedFilterset = viewData.filterset else {
            Debug.print(.error(source: .location(Source()), message: "Invalid View Data received!"))
            return
        }
        if case .model(let mini3doorSelection, let mini5doorSelection, let miniConvertibleSelection, let miniClubmanSelection, let miniCountrymanSelection, let bmwI3Selection, let bmw1erSelection, let bmwX1Selection, let bmw2erATSelection, let bmw2erConvertibleSelection, let smartForTwoSelection, let smartRoadsterSelection, let smartForFourSelection, let mercedesGLASelection, let mercedesCLASelection, let mercedesASelection, let mercedesBSelection) = displayedFilterset.modelFilter {
            let newFilter: Filter
            
            switch modelSelection {
            case .mini3Door:
                newFilter = .model(mini3door: mini3doorSelection.flipped, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .mini5Door:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection.flipped, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .miniConvertible:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection.flipped, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .miniClubman:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection.flipped, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .miniCountryman:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection.flipped, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .bmwI3:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection.flipped, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .bmw1er3Door, .bmw1er5Door:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection.flipped, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .bmwX1:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection.flipped, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .bmw2erAT:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection.flipped, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .bmw2erConvertible:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection.flipped, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .smartForTwo:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection.flipped, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .smartRoadster:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection.flipped, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .smartForFour:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection.flipped, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .mercedesGLA:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection.flipped, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .mercedesCLA:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection.flipped, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            case .mercedesAclass:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection.flipped, mercedesB: mercedesBSelection)
            case .mercedesBclass:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection.flipped)
            default:
                newFilter = .model(mini3door: mini3doorSelection, mini5door: mini5doorSelection, miniConvertible: miniConvertibleSelection, miniClubman: miniClubmanSelection, miniCountryman: miniCountrymanSelection, bmwI3: bmwI3Selection, bmw1er: bmw1erSelection, bmwX1: bmwX1Selection, bmw2erAT: bmw2erATSelection, bmw2erConvertible: bmw2erConvertibleSelection, smartForTwo: smartForTwoSelection, smartRoadster: smartRoadsterSelection, smartForFour: smartForFourSelection, mercedesGLA: mercedesGLASelection, mercedesCLA: mercedesCLASelection, mercedesA: mercedesASelection, mercedesB: mercedesBSelection)
            }
            
            displayedFilterset.update(filter: newFilter)
            presenter.updateAllElements(for: displayedFilterset)
        }
    }

}
