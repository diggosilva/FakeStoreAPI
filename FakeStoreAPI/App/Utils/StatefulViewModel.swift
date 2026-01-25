//
//  StatefulViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 25/01/26.
//

import Combine

protocol StatefulViewModel {
    associatedtype State
    var statePublisher: AnyPublisher<State, Never> { get }
}
