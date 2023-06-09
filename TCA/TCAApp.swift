//
//  TCAApp.swift
//  TCA
//
//  Created by 이기완 on 2023/03/28.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
            SharedStateView(store: Store(initialState: .init(), reducer: SharedState()))
        }
    }
}
