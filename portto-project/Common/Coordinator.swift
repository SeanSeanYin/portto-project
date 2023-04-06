//
//  Coordinator.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

protocol Coordinator: AnyObject {
    
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
