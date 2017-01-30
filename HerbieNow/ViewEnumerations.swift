//
//  ViewEnumerations.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

enum MainViewButton {
    
    case filterset(Filterset?, id: Int)
    case provider(Provider)
    case map
    
}

enum NavigationAction {

    case back
    case next
    case confirm
    case abort

}

enum View {

    case main(data: ViewData)
    case vehicleMap(data: ViewData)
    case login
    case internalModelOptions(data: ViewData)
    case externalModelOptions(data: ViewData)
    case models(data: ViewData)
    case filtersetNameAndIcon(data: ViewData)

    var viewName: String {
        switch self {
        case .main:
            return "Main View"
        case .vehicleMap:
            return "Vehicle Map View"
        case .login:
            return "Login Popup"
        case .internalModelOptions:
            return "Select Internal Model Options Popup"
        case .externalModelOptions:
            return "Select External Model Options Popup"
        case .models:
            return "Select Models Popup"
        case .filtersetNameAndIcon:
            return "Select Filterset Name and Icon Popup"
        }
    }

}

enum ViewData {

    case mainData(displayedFiltersets: [Filterset])
    case vehicleMapData(displayedVehicles: [Vehicle])
    case internalModelOptionsPopupData(Filterset)
    case externalModelOptionsPopupData(Filterset)
    case modelsPopupData(Filterset, displayedModels: [Model])
    case filtersetNameAndIconPopupData(Filterset, displayedIcons: [UIImage])

    var displayedFiltersets: [Filterset]? {
        switch self {
        case .mainData(let displayedFiltersets):
            return displayedFiltersets
        default:
            return nil
        }
    }

    var displayedVehicles: [Vehicle]? {
        switch self {
        case .vehicleMapData(let displayedVehicles):
            return displayedVehicles
        default:
            return nil
        }
    }

}

enum ViewReturnData {

    case loginPopupReturnData(username: String?, password: String?)
    case internalModelOptionsPopupReturnData()
    case externalModelOptionsPopupReturnData()
    case modelsPopupReturnData()
    case filtersetNameAndIconPopupReturnData()

    var username: String? {
        switch self {
        case .loginPopupReturnData(let username, _):
            return username
        default:
            return nil
        }
    }

    var password: String? {
        switch self {
        case .loginPopupReturnData(_, let password):
            return password
        default:
            return nil
        }
    }

}
