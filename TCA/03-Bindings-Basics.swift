//
//  01-Bindings-Basics.swift
//  TCA
//
//  Created by 이기완 on 2023/03/29.
//

import SwiftUI
import ComposableArchitecture

private let readMe = """
  This file demonstrates how to handle two-way bindings in the Composable Architecture.

  Two-way bindings in SwiftUI are powerful, but also go against the grain of the "unidirectional \
  data flow" of the Composable Architecture. This is because anything can mutate the value \
  whenever it wants.

  On the other hand, the Composable Architecture demands that mutations can only happen by sending \
  actions to the store, and this means there is only ever one place to see how the state of our \
  feature evolves, which is the reducer.

  Any SwiftUI component that requires a Binding to do its job can be used in the Composable \
  Architecture. You can derive a Binding from your ViewStore by using the `binding` method. This \
  will allow you to specify what state renders the component, and what action to send when the \
  component changes, which means you can keep using a unidirectional style for your feature.
  """

struct BindingsBasics: ReducerProtocol {
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var toggleIsOn = false
    }
    
    enum Action: Equatable {
        case sliderValueChanged(Double)
        case stepCountChanged(Int)
        case textChanged(String)
        case toggleChanged(isOn: Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .sliderValueChanged(let value):
            state.sliderValue = value
            return .none
        case .stepCountChanged(let count):
            state.stepCount = count
            return .none
        case .textChanged(let text):
            state.text = text
            return .none
        case .toggleChanged(let isOn):
            state.toggleIsOn = isOn
            return .none
        }
    }
    
}

struct BindingsBasicsView: View {
    let store: StoreOf<BindingsBasics>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    AboutView(readMe: readMe)
                }
                
                Section {
                    HStack {
                        TextField("Type Here",
                                  text: viewStore.binding(get: \.text, send: BindingsBasics.Action.textChanged))
                        
                        Text(viewStore.text)
                    }
                    
                    HStack {
                        Text("Disable other controls")
                        Toggle(isOn: viewStore.binding(get: \.toggleIsOn, send: BindingsBasics.Action.toggleChanged)) {
                        }
                    }
                    
                    
                    Stepper("Max slider value: \(viewStore.stepCount)", value: viewStore.binding(get: \.stepCount, send: BindingsBasics.Action.stepCountChanged), in: 0 ... 100)
                        .disabled(viewStore.toggleIsOn)
                    
                    
                    HStack {
                        Text("Slider Value: \(Int(viewStore.sliderValue))")
                            .monospacedDigit()
                        Slider(value: viewStore.binding(get: \.sliderValue, send: BindingsBasics.Action.sliderValueChanged), in: 0 ... 10)
                        
                    }
                    .disabled(viewStore.toggleIsOn)
                    

                }
                
            }
            .navigationTitle("Bindings Basics")
            
        }
    }
}

struct _1_Bindings_Basics_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BindingsBasicsView(store: Store(initialState: .init(), reducer: BindingsBasics()))
        }
    }
}
