//
//  04-Bindings-Forms.swift
//  TCA
//
//  Created by 이기완 on 2023/03/29.
//

import SwiftUI
import ComposableArchitecture

private let readMe = """
  This file demonstrates how to handle two-way bindings in the Composable Architecture using \
  bindable state and actions.

  Bindable state and actions allow you to safely eliminate the boilerplate caused by needing to \
  have a unique action for every UI control. Instead, all UI bindings can be consolidated into a \
  single `binding` action that holds onto a `BindingAction` value, and all bindable state can be \
  safeguarded with the `BindingState` property wrapper.

  It is instructive to compare this case study to the "Binding Basics" case study.
  """

struct BindingsForm: ReducerProtocol {
    struct State: Equatable {
        @BindingState var sliderValue = 5.0
        @BindingState var stepCount = 10
        @BindingState var text = ""
        @BindingState var toggleIsOn = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case resetButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$stepCount):
                print("step")
                state.stepCount = state.stepCount
                return .none
            case .binding:
                print("none")
                return .none
            case .resetButtonTapped:
                print("reset")
                state = State()
                return .none
            }
        }
    }
}

struct BindingsFormView: View {
    let store: StoreOf<BindingsForm>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    AboutView(readMe: readMe)
                }
                
                
                Section {
                    HStack {
                        TextField("Type Here",
                                  text: viewStore.binding(\.$text))
                        
                        Text(viewStore.text)
                    }
                    
                    HStack {
                        Text("Disable other controls")
                        Toggle(isOn: viewStore.binding(\.$toggleIsOn)) {
                        }
                    }
//
//
                    Stepper("Max slider value: \(viewStore.stepCount)", value: viewStore.binding(\.$stepCount), in: 0 ... 100)
                        .disabled(viewStore.toggleIsOn)
//
//
                    HStack {
                        Text("Slider Value: \(Int(viewStore.sliderValue))")
                            .monospacedDigit()
                        Slider(value: viewStore.binding(\.$sliderValue), in: 0 ... 10)

                    }
                    .disabled(viewStore.toggleIsOn)
                    

                    Button {
                        viewStore.send(.resetButtonTapped)
                    } label: {
                        Text("Reset")
                            .foregroundColor(.red)
                    }

                }
                
            }
            .navigationTitle("Bindings form")
            
        }
    }
}

struct BindingsFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BindingsFormView(store: Store(initialState: .init(), reducer: BindingsForm()))
        }
    }
}
