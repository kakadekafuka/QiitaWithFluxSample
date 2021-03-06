//
//  Dispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/11/20.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

protocol DispatchCompatible {
    var dispatcher: Dispatcher<Self> { get }
}

extension DispatchCompatible {
    var dispatcher: Dispatcher<Self> {
        return Dispatcher(self)
    }
}

struct Dispatcher<Base: DispatchCompatible> {
    let base: Base
    
    fileprivate init(_ dispatcher: Base) {
        self.base = dispatcher
    }
}
