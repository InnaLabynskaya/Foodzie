//
//  AppAssembler.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation
import Swinject

class AppAssembler {
    let assembler = Assembler([
        ServiceAssembly(),
        MapAssembly()
    ])
    
    var resolver: Resolver {
        assembler.resolver
    }
}
