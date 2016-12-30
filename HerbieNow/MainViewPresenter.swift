//
//  MainViewPresenter.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol MainViewPresenterProtocol {

    // This protocol contains every function, the MainViewInterpreter can call.

    func goToMapView(with filterset: Filterset?)

    //    func configureAccountButtons(with accounts: [Account])

    func configureFiltersetButtons(with filtersets: [Int : Filterset])

    func showDeleteFiltersetAlert(for filterset: Filterset)
    
    func display(message: String)

}

extension MainViewPresenterProtocol {

    func goToMapView(with filterset: Filterset? = nil) {
        goToMapView(with: filterset)
    }

}

/// The Presenter is only called by the Interpreter and structures incoming data for easier presentation by a ViewController
class MainViewPresenter {

    weak var mainVC: MainViewControllerProtocol? // avoiding a retain cycle with this weak reference

    init(to mainViewController: MainViewControllerProtocol? = nil) {
        mainVC = mainViewController
    }

}

extension MainViewPresenter: MainViewPresenterProtocol {

    func goToMapView(with filterset: Filterset?) {
        if let selectedFilterset = filterset {
            mainVC?.goToMapView(with: selectedFilterset)
        } else {
            mainVC?.goToMapViewWithoutFilter()
        }
    }

    //    func configureAccountButtons(with accounts: [Account]) {

    //        // TODO: activate or deactivate account buttons

    //    }

    func configureFiltersetButtons(with filtersets: [Int : Filterset]) {

        // TODO: activate or deactivate filterset buttons

    }

    func showDeleteFiltersetAlert(for filterset: Filterset) {

        // TODO: present alert

    }
    
    func display(message: String) {
        // mainVC . do something
        print(message)
    }

}
