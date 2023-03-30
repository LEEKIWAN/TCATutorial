//
//  01-Counter.swift
//  TCA
//
//  Created by 이기완 on 2023/03/29.
//

import SwiftUI
import ComposableArchitecture

private let readMe = """
  This screen demonstrates the basics of the Composable Architecture in an archetypal counter \
  application.

  The domain of the application is modeled using simple data types that correspond to the mutable \
  state of the application and any actions that can affect that state or the outside world.
  """

struct Counter: ReducerProtocol {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .incrementButtonTapped:
            state.count += 1
            return .none
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center) {
                Button {
                    viewStore.send(.decrementButtonTapped)
                } label: {
                    Image(systemName: "minus")
                }
                
                Text("\(viewStore.count)")
                    .monospacedDigit()
                Button {
                    viewStore.send(.incrementButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        
        
    }
}

struct CounterDemoView: View {
    let store: StoreOf<Counter>
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    AboutView(readMe: readMe)
                }
                
                Section {
                    CounterView(store: store)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderless)

            .navigationTitle("Counter Demo")
        }
        
    }
}

struct CounterDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CounterDemoView(store: Store(initialState: Counter.State(), reducer: Counter()))
    }
}
