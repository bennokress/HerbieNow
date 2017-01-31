//
//  ViewEnumerations.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    
    // -> Explanation here: https://medium.com/@gurdeep060289/clean-code-for-multiple-storyboards-c64eb679dbf6#.z2yrmjsei
    
    case main = "Main"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as!T
    }
    
}

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

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
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

    case mainData(displayedFiltersets: [Filterset?], driveNowActive: Bool, car2goActive: Bool)
    case vehicleMapData(displayedVehicles: [Vehicle])
    case internalModelOptionsPopupData(Filterset)
    case externalModelOptionsPopupData(Filterset)
    case modelsPopupData(Filterset, displayedModels: [Model])
    case filtersetNameAndIconPopupData(Filterset, displayedIcons: [UIImage])

    var displayedFiltersets: [Filterset?]? {
        switch self {
        case .mainData(let displayedFiltersets, _, _):
            return displayedFiltersets
        default:
            return nil
        }
    }
    
    var driveNowConfigured: Bool? {
        switch self {
        case .mainData(_ , let driveNowActive, _):
            return driveNowActive
        default:
            return nil
        }
    }
    
    var car2goConfigured: Bool? {
        switch self {
        case .mainData(_ , _, let car2goActive):
            return car2goActive
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
    
    var filterset: Filterset? {
        switch self {
        case .internalModelOptionsPopupData(let filterset), .externalModelOptionsPopupData(let filterset), .modelsPopupData(let filterset, _), .filtersetNameAndIconPopupData(let filterset, _):
            return filterset
        default:
            return nil
        }
    }
    
    var displayedModels: [Model]? {
        switch self {
        case .modelsPopupData(_, let displayedModels):
            return displayedModels
        default:
            return nil
        }
    }
    
    var displayedIcons: [UIImage]? {
        switch self {
        case .filtersetNameAndIconPopupData(_, let displayedIcons):
            return displayedIcons
        default:
            return nil
        }
    }

}

enum ViewReturnData {

    case loginPopupReturnData(username: String?, password: String?)
    case internalModelOptionsPopupReturnData(filtersetConfiguration: Filterset)
    case externalModelOptionsPopupReturnData(filtersetConfiguration: Filterset)
    case modelsPopupReturnData(filtersetConfiguration: Filterset)
    case filtersetNameAndIconPopupReturnData(filtersetConfiguration: Filterset)
    case noReturnData

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
    
    var filterset: Filterset? {
        switch self {
        case .internalModelOptionsPopupReturnData(let filterset), .externalModelOptionsPopupReturnData(let filterset),
             .modelsPopupReturnData(let filterset), .filtersetNameAndIconPopupReturnData(let filterset):
            return filterset
        default:
            return nil
        }
    }

}
