//
//  05-OptionalState2.swift
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

struct OptionalState2: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Int?
    }
    
    enum Action: Equatable {
        case incrementCounter
        case decrementCounter
        case toggleButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleButtonTapped:
                state.optionalCounter = state.optionalCounter == nil ? 0 : nil
                return .none
            case .decrementCounter:
                state.optionalCounter! -= 1
                return .none
            case .incrementCounter:
                state.optionalCounter! += 1
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: /Action.incrementCounter) {
//            Counter()
//            Int
        }
        
    }
}

struct OptionalStateView2: View {
    let store: StoreOf<OptionalState2>
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
                    
                    IfLetStore(store.scope(state: \.optionalCounter),
                               then: { _ in
                        Text("`CounterState` is non-`nil'")


                        HStack {
                            Button {
                                viewStore.send(.decrementCounter)
                            } label: {
                                Text("-")
                            }

                            Text("\(viewStore.optionalCounter ?? 0)")

                            Button {
                                viewStore.send(.incrementCounter)
                            } label: {
                                Text("+")
                            }
                        }

                    },
                               else: {

                        Text("fff")
                    })
                    
//
//                    IfLetStore(store.scope(state: \.optionalCounter, action: OptionalState2.Action.incrementCounter),
//                               then: { store in
//
//                        Text("`CounterState` is non-`nil`")
//                        CounterView(store: store)
//                            .buttonStyle(.borderless)
//                            .frame(maxWidth: .infinity)
//                    }, else: {
//                        Text("`CounterState` is `nil`")
//                    })
                    
                    
                    
                    
                    
                }
            }
            .buttonStyle(.borderless)
            .navigationTitle("Optional State")
        }
        
    }
}

struct OptionalStateView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OptionalStateView2(store: Store(initialState: .init(), reducer: OptionalState2()))
        }
        
    }
}
