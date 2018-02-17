//
//  Store+Language.swift
//  RxRedux
//
//  Created by Chris Nevin on 17/02/2018.
//  Copyright © 2018 Chris Nevin. All rights reserved.
//

import RxSwift

extension Store where StateType == AppState {
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, T>) -> Observable<T> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
    
    func localizedObserve<T: Equatable>(_ keyPath: KeyPath<StateType, [T]>) -> Observable<[T]> {
        return Observable.combineLatest(
            observe(\AppState.languageState.current),
            observe(keyPath)) { $1 }
    }
}
