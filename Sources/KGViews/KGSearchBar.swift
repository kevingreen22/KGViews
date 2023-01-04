//
//  KGSearchBar.swift
//
//  Created by Kevin Green on 11/16/22.
//

import SwiftUI
import UIKit

/// A search bar with cancel button and x button to clear search text. Works just like Apple standard search bar.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct KGSearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    var cancelButtonColor: Color
    
    @State private var showX = false
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState var focused: Bool
    private var lightGrayLight: Color = Color(red: 227/255, green: 230/255, blue: 230/255)
    private var lightGrayDark: Color = Color(red: 37/255, green: 38/255, blue: 38/255)
    
    public init(searchText: Binding<String>, searching: Binding<Bool>, cancelButtonColor: Color = .blue) {
        _searchText = searchText
        _searching = searching
        self.cancelButtonColor = cancelButtonColor
    }
    
    
    public var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $searchText) { startEditing in
                        if startEditing {
                            withAnimation {
                                searching = true
                            }
                        }
                    } onCommit: {
                        withAnimation {
                            searching = false
                        }
                    }
                    .frame(height: 40)
                    .focused($focused)
                    .onChange(of: searchText) { newValue in
                        withAnimation {
                            (newValue != "") ? (showX = true) : (showX = false)
                        }
                    }
                    
                    if showX {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .frame(height: 40)
                .padding(.horizontal)
                
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(colorScheme == .light ? lightGrayLight : lightGrayDark)
                }
                
                if searching {
                    Button {
                        // cancel searching
                        withAnimation {
                            searching = false
                            focused = false
                            showX = false
                            searchText = ""
                            dismissKeyboard()
                        }
                    } label: {
                        Text("Cancel")
                            .foregroundColor(cancelButtonColor)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(height: 40)
    }
    
    #if canImport(UIKit)
    fileprivate func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
    
}





// MARK: Preview
private struct SearchBar_Preview: PreviewProvider {
    static var searchText = ""
    static var searching = false
    
    static var previews: some View {
        let searchTxt: Binding<String> = Binding(get: { self.searchText }, set: { self.searchText = $0 })
        let isSearching: Binding<Bool> = Binding(get: { self.searching }, set: { self.searching = $0 })
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    KGSearchBar(searchText: searchTxt, searching: isSearching)
                        .padding(.horizontal)
                }
            }
            
            .navigationTitle("Search")
        }
        .navigationViewStyle(.stack)
    }
}
