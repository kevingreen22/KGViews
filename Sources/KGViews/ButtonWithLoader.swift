//
//  ButtonWithLoader.swift
//
//  Created by Kevin Green on 10/27/22.
//
import SwiftUI

public struct ButtonWithLoader<Label: View>: View {
    var action: ()async->Void
    var buttonRole: ButtonRole?
    var actionOptions = Set(ActionOptions.allCases)
    @ViewBuilder var label: ()->Label
    
    @State private var showProgressView: Bool = false
    @State private var isDisabled: Bool = false
    
    public init(action: @escaping ()async->Void,
                buttonRole: ButtonRole? = nil,
                actionOptions: Swift.Set<ActionOptions> = Set(ActionOptions.allCases),
                @ViewBuilder label: @escaping ()->Label
    ) {
        self.action = action
        self.buttonRole = buttonRole
        self.actionOptions = actionOptions
        self.label = label
        self.showProgressView = showProgressView
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        Button(role: buttonRole) {
            if actionOptions.contains(.disableButton) {
                isDisabled = true
            }
            
            Task {
                var progressViewTask: Task<Void, Error>?
                
                if actionOptions.contains(.showProgressView) {
                    progressViewTask = Task {
                        try await Task.sleep(nanoseconds: 150_000_000)
                        showProgressView = true
                    }
                }
                
                await action()
                progressViewTask?.cancel()
                
                isDisabled = false
                showProgressView = false
            }
        } label: {
            label()
                .opacity(showProgressView ? 0 : 1)
                .overlay {
                    if showProgressView {
                        ProgressView()
                    }
                }
        }
        .allowsHitTesting(!isDisabled)
    }
}


public extension ButtonWithLoader {
    enum ActionOptions: CaseIterable {
        case disableButton
        case showProgressView
    }
}


public extension Button {
    
    /// Adds a progress loader on top of the button.
    func withLoader(_ showLoader: Binding<Bool>) -> some View {
        self.overlay {
                if showLoader.wrappedValue {  ProgressView() }
            }.allowsHitTesting(showLoader.wrappedValue ? false : true)
    }
    
}


/// Scales the button view down when pressed, and back up when let go.
/// The total durataion is 0.5 seconds. When adding a visual animation/transition after the press of the button, be sure to delay that animation/transition this amount of time.
public struct KGScaledButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == KGScaledButtonStyle {
    static var scaled: KGScaledButtonStyle {
        return KGScaledButtonStyle()
    }
}


// MARK: LoadingButton and Styles Demo
fileprivate struct LoadingButton_Demo: View {
    @State private var showLoader = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Button Loaders").font(.title)
                
                Button {
                    withAnimation { showLoader.toggle() }
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        withAnimation { showLoader.toggle() }
                    }
                } label: {
                    Text("Button using modifier")
                }
                .withLoader($showLoader)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                
                ButtonWithLoader {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                } label: {
                    Label("Button as View", systemImage: "person.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
            }
            
            Spacer()
            
            VStack {
                Text("Button Styles").font(.title)
                
                Button {
                    //
                } label: {
                    Text("Button with ScaledButtonStyle")
                        .padding()
                        .foregroundStyle(Color.white)
                        .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 8)))
                }
                .buttonStyle(KGScaledButtonStyle())
                .controlSize(.large)
                
            }
            
            Spacer()
        }
    }
}

#Preview {
    LoadingButton_Demo()
}
