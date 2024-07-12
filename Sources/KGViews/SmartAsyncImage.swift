//
//  SmartAsyncImage.swift
//
//  Created by Kevin Green on 9/15/22.
//

import SwiftUI

public struct SmartAsyncImage: View {
    var contentMode: ContentMode
    var urlString: String?
    var imageData: Data?
    var defaultImage: Image?
    
    public init(contentMode: ContentMode = .fit, urlString: String?, imageData: Data? = nil, defaultImage: Image? = nil) {
        self.contentMode = contentMode
        self.urlString = urlString
        self.imageData = imageData
        self.defaultImage = defaultImage
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            if let imageData = imageData, let uiimage = UIImage(data: imageData) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: size.width, height: size.height)
                
            } else if let urlString = urlString {
                let url = URL(string: urlString)
                AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .frame(width: size.width, height: size.height)
                    case .empty:
                        ProgressView()
                            .offset(x: size.width / 2 - 10, y: size.height / 2 - 10)
                    default:
                        defaultImage(proxy)
                    }
                }
            } else {
                defaultImage(proxy)
            }
        }
    }
    
    fileprivate func defaultImage(_ proxy: GeometryProxy) -> some View {
        if let image = defaultImage {
            return image
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .opacity(0.1)
                .frame(width: proxy.size.width, height: proxy.size.height)
        } else {
            return Image(uiImage: UIImage())
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .opacity(0.1)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}


// MARK: Smart Async Image Demo
fileprivate struct SmartAsyncImage_Demo: PreviewProvider {
    static var previews: some View {
        SmartAsyncImage(urlString: "https://picsum.photos/200")
    }
}

#Preview {
    SmartAsyncImage(urlString: "https://picsum.photos/200")
}
