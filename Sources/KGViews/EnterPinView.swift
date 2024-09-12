//
//  EnterPinView.swift
//
//  Created by Kevin Green on 10/11/20.
//

import SwiftUI
import Biometrics
import HapticManager

@available(iOS 14.0, *)
public struct EnterPinView: View {
    @Binding var isUnlocked: Bool
    var accentColor: Color = .accentColor
    
    public init(isUnlocked: Binding<Bool>, accentColor: Color = .accentColor) {
        _isUnlocked = isUnlocked
        self.accentColor = accentColor
    }
    
    @State private var first = ""
    @State private var second = ""
    @State private var third = ""
    @State private var fourth = ""
    @State private var tempCode = ""
    @State private var lastAddedCircleIndex = 0
    @State private var attempts: Int = 0
    @State private var alert: Alert?
        
    @AppStorage("passcode") private var passcode: String = ""
    @AppStorage("isCreatingPasscode") private var isCreatingPasscode: Bool = false
    
    private var Bio = Biometrics.instance
    private var haptics = HapticManager.instance
    
    public var body: some View {
        VStack {
            Spacer()
                .onAppear {
                    if passcode == "" {
                        isCreatingPasscode = true
                    } else {
                        Bio.authenticate { success in
                            self.isUnlocked = success
                        }
                    }
                }
            
            isCreatingPasscode ? Text((tempCode == "") ? "Create a Pin" : "Enter your pin again.")
                .font(.title).padding() : Text("Enter Your Pin")
                .foregroundColor(accentColor)
                .font(.title)
                .padding()
            
            HStack {
                Image(systemName: (first == "") ? "circle" : "circle.fill")
                Image(systemName: (second == "") ? "circle" : "circle.fill")
                Image(systemName: (third == "") ? "circle" : "circle.fill")
                Image(systemName: (fourth == "") ? "circle" : "circle.fill")
                    .onChange(of: fourth, perform: { value in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if value != "" { processPasscodes() }
                        }
                    })
            }
            .modifier(Shake(animatableData: CGFloat(attempts)))
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("1")
                }, label: {
                    Text("1")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("2")
                }, label: {
                    Text("2")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("3")
                }, label: {
                    Text("3")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("4")
                }, label: {
                    Text("4")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("5")
                }, label: {
                    Text("5")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("6")
                }, label: {
                    Text("6")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("7")
                }, label: {
                    Text("7")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("8")
                }, label: {
                    Text("8")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("9")
                }, label: {
                    Text("9")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    // Activate face ID
                    print("\(type(of: self)).face_id_button_pressed")
                    Bio.authenticate { success in
                        if success {
                            self.isUnlocked = success
                        } else {
                            alert = enableFaceIDAlert
                        }
                    }
                }, label: {
                    Image(systemName: "faceid")
                        .foregroundColor(accentColor)
                        .font(.title)
                        .padding()
                })
                .disabled(isCreatingPasscode)
                
                Spacer()
                Button(action: {
                    updateSecureCircles("0")
                }, label: {
                    Text("0")
                        .foregroundColor(accentColor)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    print("\(type(of: self)).delete_pressed")
                    updateSecureCircles(nil, isDeleteing: true, forCircle: lastAddedCircleIndex)
                }, label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(accentColor)
                        .font(.title)
                        .padding()
                })
                Spacer()
            }
        }
                
        .alert(item: $alert) { alert in alert }
    }
    
    fileprivate func getEnteredCode() -> String {
        let enteredCode = first + second + third + fourth
        return enteredCode
    }
    
    fileprivate func clearEnteredCode() {
        first = ""
        second = ""
        third = ""
        fourth = ""
    }
    
    fileprivate func updateSecureCircles(_ number: String?, isDeleteing: Bool = false, forCircle index: Int? = nil) {
        switch isDeleteing {
        case true:
            switch index {
            case 1:
                first = ""
                lastAddedCircleIndex = 0
            case 2:
                second = ""
                lastAddedCircleIndex = 1
            case 3:
                third = ""
                lastAddedCircleIndex = 2
            case 4:
                fourth = ""
                lastAddedCircleIndex = 3
            default:
                break
            }
            
        case false:
            guard let number = number else { return }
            if first == "" {
                first = number
                lastAddedCircleIndex = 1
            } else if second == "" {
                second = number
                lastAddedCircleIndex = 2
            } else if third == "" {
                third = number
                lastAddedCircleIndex = 3
            } else if fourth == "" {
                fourth = number
            }
        }
    }
    
    fileprivate func processPasscodes() {
        switch isCreatingPasscode {
        
        // Verifying passcode entered
        case false:
            let enteredCode = getEnteredCode()
            if enteredCode == passcode && fourth != "" {
                print("\(type(of: self)).correct_passcode_entered")
                haptics.success()
                isUnlocked = true
            } else if enteredCode.count == 4 {
                print("\(type(of: self)).wrong_passcode_entered: \(passcode)")
                haptics.error()
                // animate circles to shake
                withAnimation(.default) {
                    self.attempts += 1
                }
                clearEnteredCode()
            }
            
        // Creating passcode, requires to enter the code twice
        case true:
            switch tempCode {
            case "":
                // First time entered
                tempCode = getEnteredCode()
                clearEnteredCode()
                
            default:
                if tempCode != "" {
                    // Second time entered
                    let secondEnteredCode = getEnteredCode()
                    // Check if both codes match
                    if tempCode != secondEnteredCode {
                        // Passcodes don't match
                        // Show alert and start over
                        haptics.error()
                        clearEnteredCode()
                        tempCode = ""
                        alert = wrongPinAlert
                    } else {
                        // Both passcodes match
                        haptics.success()
                        isUnlocked = true
                        passcode = secondEnteredCode
                        isCreatingPasscode = false
                    }
                }
            }
        }
    }
    
    fileprivate var enableFaceIDAlert: Alert {
        Alert(
            title: Text("Enable Face ID?"),
            message: Text("You must enable Face ID in your device settings in order to use Face ID."),
            primaryButton: .default(Text("Ok")),
            secondaryButton: .default(
                Text("Open Settings"),
                action: {
                    guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil
                    )
                }
            )
        )
    }
    
    fileprivate var wrongPinAlert: Alert {
        Alert(
            title: Text("Wrong Pin"),
            message: Text("Both pins must match."),
            dismissButton: .cancel(Text("Ok")))
    }
}


extension Alert: Identifiable {
    public var id: String { UUID().uuidString }
}


private struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}



// MARK: Preview
@available(iOS 14.0, *)
#Preview {
    EnterPinView(isUnlocked: .constant(false))
}
