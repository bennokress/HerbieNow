//
//  EmptyProtocols.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.01.17.
//  Copyright © 2017 LMU. All rights reserved.
//

// MARK: - General
protocol InternalRouting { }
protocol ComputedProperties { }

// MARK: - AppData
protocol AddData { }
protocol GetData { }

// MARK: - Logic
protocol APIWrapper { }
protocol AppDataWrapper { }

// MARK: - Interpreter
protocol LogicConnection { }
protocol PresenterConnection { }

// MARK: - Presenter
protocol ViewDataPreparation { }

// MARK: - View Controllers
protocol PopupSetup { }
