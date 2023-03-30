//
//  05-OptionalState.swift
//  TCA
//
//  Created by 이기완 on 2023/03/29.
//

import SwiftUI
import ComposableArchitecture
private let readMe = """
  This screen demonstrates how to show and hide views based on the presence of some optional child \
  state.

  The parent state holds a `CounterState?` value. When it is `nil` we will default to a plain text \
  view. But when it is non-`nil` we will show a view fragment for a counter that operates on the \
  non-optional counter state.

  Tapping "Toggle counter state" will flip between the `nil` and non-`nil` counter states.
  """

struct OptionalState: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Counter.State?
    }
    
    enum Action: Equatable {
        case optionalCounter(Counter.Action)
        case toggleButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
//        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .toggleButtonTapped:
                state.optionalCounter = state.optionalCounter == nil ? Counter.State() : nil
                return .none                
            case .optionalCounter:
                return .none
            }

        }
        .ifLet(\.optionalCounter, action: /Action.optionalCounter) {
            Counter()
        }
        
    }
}

struct OptionalStateView: View {
    let store: StoreOf<OptionalState>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    AboutView(readMe: readMe)
                }
                
                Section {
                    Button("Toggle Counter State") {
                        viewStore.send(.toggleButtonTapped)
                    }
                    
                    
                    IfLetStore(store.scope(state: \.optionalCounter, action: OptionalState.Action.optionalCounter),
                               then: { store in
                        
                        Text("`CounterState` is non-`nil`")
                        CounterView(store: store)
                            .buttonStyle(.borderless)
                            .frame(maxWidth: .infinity)
                    }, else: {
                        Text("`CounterState` is `nil`")
                    })
                    
//                    IfLetStore(store.scope(state: \.optionalCounter, action: OptionalState.action.optionalCounter),
//                               then: { store in
//                        Text("`CounterState` is non-`nil`")
//                        CounterView(store: store)
//                          .buttonStyle(.borderless)
//                          .frame(maxWidth: .infinity)
//
//                    }, else: {
//                        Text("`CounterState` is `nil`")
//                    })

                    
                    
                }
            }
            .navigationTitle("Optional State")
        }
        
    }
}

struct OptionalStateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OptionalStateView(store: Store(initialState: .init(), reducer: OptionalState()))
        }
        
    }
}
