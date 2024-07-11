//
//  TextFields.swift
//
//  Created by Kevin Green on 8/18/22.
//

import SwiftUI

public struct KGTextFieldStyle<S: Shape>: TextFieldStyle {
    var image: Image?
    var imageColor: Color
    var backgroundColor: Color
    var keyboardType: UIKeyboardType
    var font: Font
    var shape: S
    
    
    public init(image: Image?, imageColor: Color = Color(uiColor: UIColor.systemGray), backgroundColor: Color = Color(uiColor: .systemBackground), keyboardType: UIKeyboardType = .default, font: Font = .body, shape: S = Capsule()) {
        self.image = image
        self.imageColor = imageColor
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
        self.font = font
        self.shape = shape
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if let image = image {
                image
                    .foregroundColor(imageColor)
            }
            
            configuration
                .keyboardType(keyboardType)
                .font(font)
        }
        .padding()
        .background(shape.fill(backgroundColor))
    }
}


public struct KGPasswordTextFieldStyle<S: Shape>: TextFieldStyle {
    var placeholder: String
    @Binding var text: String
    var imageColor: Color
    var backgroundColor: Color
    var shape: S
    
    public init(placeholder: String, text: Binding<String>, imageColor: Color = .secondary, backgroundColor: Color = .white, shape: S = Capsule()) {
        self.placeholder = placeholder
        _text = text
        self.imageColor = imageColor
        self.backgroundColor = backgroundColor
        self.shape = shape
    }
    
    @State private var showPassword = false
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(imageColor)
            
            if showPassword {
                configuration
            } else {
                SecureField(placeholder, text: $text)
            }
            
            Button(action: { self.showPassword.toggle()}) {
                Image(systemName: "eye")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(shape.fill(backgroundColor))
    }
}


public extension TextField {
    
    func visualValidate(value: String, validator: ValidatorStyle, alignment: Alignment = .bottom, sizeFactor: CGFloat = 0.10) -> some View {
        GeometryReader { proxy in
            switch validator {
            case .blank:
                self.overlay(alignment: alignment) {
                    barValidatorView(value, proxy: proxy, sizeFactor: sizeFactor, validationStyle: validator)
                }.frame(width: proxy.size.width, height: proxy.size.height)
                
            case .minCharacters(_):
                self.overlay(alignment: alignment) {
                    barValidatorView(value, proxy: proxy, sizeFactor: sizeFactor, validationStyle: validator)
                }.frame(width: proxy.size.width, height: proxy.size.height)
                
            case .phone:
                self.overlay(alignment: alignment) {
                    barValidatorView(value, proxy: proxy, sizeFactor: sizeFactor, validationStyle: validator)
                }.frame(width: proxy.size.width, height: proxy.size.height)
                
            case .email:
                self.overlay(alignment: alignment) {
                    barValidatorView(value, proxy: proxy, sizeFactor: sizeFactor, validationStyle: validator)
                }.frame(width: proxy.size.width, height: proxy.size.height)
                
            case .password:
                self.overlay(alignment: alignment) {
                    barValidatorView(value, proxy: proxy, sizeFactor: sizeFactor, validationStyle: validator)
                }.frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }

    @ViewBuilder
    fileprivate func barValidatorView(_ value: String, proxy: GeometryProxy, sizeFactor: CGFloat, validationStyle style: ValidatorStyle) -> some View {
        if value != "" {
            VStack {
                Spacer(minLength: proxy.size.height - (proxy.size.height * sizeFactor))
                Rectangle()
                    .fill(validate(value: value, style) ? Color.green : Color.red)
                    .frame(height: proxy.size.height * sizeFactor)
                    .animation(.spring(), value: value)
                    .clipped()
            }
        }
    }
    
    fileprivate func validate(value: String, _ style: ValidatorStyle) -> Bool {
        switch style {
        case .blank: return value != ""
        case .minCharacters(let numChar): return value.count >= numChar
        case .phone: return value.isValidPhoneNumber()
        case .email: return value.isValidEmail()
        case .password: return value.isValidPassword()
        }
    }
}


// MARK: Validator Style
/// A style of validation.
public enum ValidatorStyle {
    case blank
    case minCharacters(Int)
    case email
    case phone
    case password
}


public extension String {
    
    /// Validates a phone number.
    ///
    /// Regardless of the way the phone number is entered, the capture groups can be used to breakdown the phone number so you can process it in your code.
    ///
    /// Group1: Country Code (ex: 1 or 86)
    ///
    /// Group2: Area Code (ex: 800)
    ///
    /// Group3: Exchange (ex: 555)
    ///
    /// Group4: Subscriber Number (ex: 1234)
    ///
    /// Group5: Extension (ex: 5678)
    ///
    ///```
    /// ^\s*                // Line start, match any whitespaces at the beginning if any.
    /// (?:\+?(\d{1,3}))?   // GROUP 1: The country code. Optional.
    /// [-. (]*             // Allow certain non numeric characters that may appear between the Country Code and the Area Code.
    /// (\d{3})             // GROUP 2: The Area Code. Required.
    /// [-. )]*             // Allow certain non numeric characters that may appear between the Area Code(zip code, postal code) and the Exchange number.
    /// (\d{3})             // GROUP 3: The Exchange number. Required.
    /// [-. ]*              // Allow certain non numeric characters that may appear between the Exchange number and the Subscriber number.
    /// (\d{4})             // Group 4: The Subscriber Number. Required.
    /// (?: *x(\d+))?       // Group 5: The Extension number. Optional.
    /// \s*$                // Match any ending whitespaces if any and the end of string.
    ///```
    ///
    /// Matching examples:
    ///
    /// 18005551234
    ///
    /// 1 800 555 1234
    ///
    /// +1 800 555-1234
    ///
    /// +86 800 555 1234
    ///
    /// 1-800-555-1234
    ///
    /// 1 (800) 555-1234
    ///
    /// (800)555-1234
    ///
    /// (800) 555-1234
    ///
    /// (800)5551234
    ///
    /// 800-555-1234
    ///
    /// 800.555.1234
    ///
    /// 800 555 1234x5678
    ///
    /// 8005551234 x5678
    ///
    /// 1    800    555-1234
    ///
    /// 1----800----555-1234
    ///
    func isValidPhoneNumber() -> Bool {
        let phone = self.trimmingCharacters(in: .whitespaces)
        let phone_regex = "^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phone_regex)
        return  phonePredicate.evaluate(with: phone)
    }
    
    
    /// Validates an email address.
    /// - Returns: True if valid, false otherwise.
    func isValidEmail() -> Bool {
        let email = self.trimmingCharacters(in: .whitespaces)
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    
    /// Validates a password.
    ///
    /// More than 6 characters, with at least one capital, numeric or special character:
    /// "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&?&]).*$"
    ///
    /// Minimum 8 characters at least 1 Alphabet and 1 Number:
    /// "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    ///
    /// Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
    /// "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    ///
    /// Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
    ///
    /// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
    ///
    /// Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
    ///
    /// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    ///
    /// Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
    ///
    /// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
    ///
    /// - Parameter style: Optionally set a style of password to use. Defaults to Minimum 8 characters at least 1 Alphabet and 1 Number.
    /// - Returns: True if valid, false otherwise.
    ///
    func isValidPassword(_ style: PasswordStyle = ._8_1Alphabet_and_1Num) -> Bool {
        let pw = self.trimmingCharacters(in: .whitespaces)
        var pattern = ""
        
        switch style {
        case ._6_1Capital_or_1Num_or_1Special:
            pattern = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&?&]).*$"
        case ._8_1Alphabet_and_1Num:
            pattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        case ._8_1Alphabet_and_1Num_and_1Special:
            pattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        case ._8_1Upper_and_1Lower_and_1Num:
            pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        case ._8_1Upper_and_1Lower_and_1Num_and_1Special:
            pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        case ._min8_Max10_and_1Upper_and_1Lower_and_1Num_and_1Special:
            pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
        }
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return passwordPredicate.evaluate(with: pw)
    }
    
    enum PasswordStyle {
        case _6_1Capital_or_1Num_or_1Special
        case _8_1Alphabet_and_1Num
        case _8_1Alphabet_and_1Num_and_1Special
        case _8_1Upper_and_1Lower_and_1Num
        case _8_1Upper_and_1Lower_and_1Num_and_1Special
        case _min8_Max10_and_1Upper_and_1Lower_and_1Num_and_1Special
    }
    
    
    /// ^                         Start anchor
    /// (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
    /// (?=.*[!@#$&*])            Ensure string has one special case letter.
    /// (?=.*[0-9].*[0-9])        Ensure string has two digits.
    /// (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
    /// .{8}                      Ensure string is of length 8.
    /// $                         End anchor.
    /// "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
    
    
}


// MARK: Text Fields Demo
fileprivate struct TextFields_DemoView: View {
    @State var text: String = ""
    @State var currencyValue: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                TextField("KG TextField Style", text: $text)
                    .visualValidate(value: text, validator: .blank)
                    .textFieldStyle(KGTextFieldStyle(image: Image(systemName: "star"), imageColor: .indigo, keyboardType: .twitter, shape: RoundedRectangle(cornerRadius: 10, style: .continuous)))
                
                TextField("Minimum Characters", text: $text)
                    .visualValidate(value: text, validator: .minCharacters(6))
                    .textFieldStyle(KGTextFieldStyle(image: Image(systemName: "number"), imageColor: .indigo, keyboardType: .twitter, shape: RoundedRectangle(cornerRadius: 10, style: .continuous)))
                
                TextField("Phone Number", text: $text)
                    .visualValidate(value: text, validator: .phone)
                    .textFieldStyle(KGTextFieldStyle(image: Image(systemName: "phone")))
                
                TextField("Email", text: $text)
                    .visualValidate(value: text, validator: .email)
                    .textFieldStyle(KGTextFieldStyle(image: Image(systemName: "envelope")))
                
                TextField("Password TextField Style", text: $text)
                    .visualValidate(value: text, validator: .password)
                    .textFieldStyle(KGPasswordTextFieldStyle(placeholder: "Password TextField Style", text: .constant("")))
                
            }.padding()
        }
    }
}

fileprivate struct TextFields_Demo: PreviewProvider {
    static var previews: some View {
        TextFields_DemoView()
    }
}

#Preview {
    TextFields_DemoView()
}
