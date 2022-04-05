//
//  HabitsAssembler.swift
//  happit
//
//  Created by Андрей  on 19.03.2022.
//

import Foundation
import UIKit

class HabitsAssembler {
    static func createModuleFromView(view calledView: HabitsViewController) {
        //Init VIPER
//        let tableView = HabitsTableViewController()
        let presenter = HabitsPresenter()
        let router = HabitsRouter()
        let network = HabitsNetworkService(auth: "d71d6096-621c-4bf0-8a31-c887e7027d5e")
        let coredata = HabitsCoreDataService()
        let interactor = HabitsInteractor(network: network, coredata: coredata)
        
        //VIEW -> PRESENTER
        calledView.presenter = presenter
        
        //PRESENTER -> VIEW
        presenter.view = calledView
        
        //PRESENTER -> INTERACTOR, ROUTER
        presenter.interactor = interactor
        presenter.router = router
        
        //INTERACTOR, ROUTER -> PRESENTER
        interactor.presenter = presenter
        router.presenter = presenter
    }
}
