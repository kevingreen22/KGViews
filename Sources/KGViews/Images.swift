//
//  Image.swift
//
//  Created by Kevin Green on 10/19/23.
//

import SwiftUI

public extension Image {
    
    /// Initializes an new Image view with the UIImage passed or a system icon.
    /// - Parameters:
    ///   - uiimage: An optional UIImage object.
    ///   - systemName: The name of an SF symbol. Default is "person.circle.fill":
    init(uiimage: UIImage?, systemName: String = "person.circle.fill") {
        if let uiimage = uiimage {
            self.init(uiImage: uiimage)
        } else {
            self.init(systemName: systemName)
        }
    }
    
}


// MARK: Image with Default Demo
fileprivate struct ImageWithDefault_Demo: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            
            Text("Image(uiimage: nil, systemName: \"paintpalette.fill\")")
            Image(uiimage: nil, systemName: "paintpalette.fill")
                .scaleEffect(5)
                .padding(.vertical, 25)
            
            Spacer()
            
            Text("Image(uiimage: nil)")
            Image(uiimage: nil)
                .scaleEffect(5)
                .padding(.vertical, 25)
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        Spacer()
        
        Text("Image(uiimage: nil, systemName: \"paintpalette.fill\")")
        Image(uiimage: nil, systemName: "paintpalette.fill")
            .scaleEffect(5)
            .padding(.vertical, 25)
        
        Spacer()
        
        Text("Image(uiimage: nil)")
        Image(uiimage: nil)
            .scaleEffect(5)
            .padding(.vertical, 25)
        
        Spacer()
    }
}
