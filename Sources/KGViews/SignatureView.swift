//
//  SignatureView.swift
//
//  Created by Kevin Green on 8/13/22.
//

import SwiftUI
import CoreGraphics

public struct SignatureView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var lineColor: Color = .black
    @Binding var disableUserInteraction: Bool
    var placeholder: Text = Text("Sign Here")
    var lineWidth: CGFloat = 3
    var showColorPicker: Bool = false
    var saveImageLocally: Bool = false
    var onClear: (() -> Void)? = nil
    var onEnded: (UIImage) -> Void
    
    @State private var drawing = DrawingPath()
    @State private var image = UIImage()
    @State private var isImageSet = false
    
    public init(
        disableUserInteraction: Binding<Bool>,
        lineColor: Color = .black,
        placeholder: Text = Text("Sign Here"),
        lineWidth: CGFloat = 3,
        showColorPicker: Bool = false,
        saveImageLocally: Bool = false,
        onClear: (() -> Void)? = nil,
        onEnded: @escaping (UIImage) -> Void
    ) {
        _disableUserInteraction = disableUserInteraction
        self.onEnded = onEnded
        self.lineColor = lineColor
        self.placeholder = placeholder
        self.lineWidth = lineWidth
        self.showColorPicker = showColorPicker
        self.saveImageLocally = saveImageLocally
        self.onClear = onClear
    }
    
    public var body: some View {
        ZStack {
            signatureContent
                .allowsHitTesting(!disableUserInteraction)
                .overlay(alignment: .topTrailing) {
                    Button {
                        clear { onClear?() }
                    } label: {
                        Text("Clear")
                    }
                    .disabled(disableUserInteraction)
                    .padding()
                    .padding(.trailing, 30)
                }
            
                .overlay(alignment: .bottomTrailing) {
                    if showColorPicker {
                        ColorPickerCompat(selection: $lineColor /*getLineColor()*/)
                            .padding()
                            .allowsHitTesting(!disableUserInteraction)
                    }
                }
        }
    }
    
    var signatureContent: some View {
        SignatureDrawView(onEnded: onEnded, drawing: $drawing, lineColor: $lineColor, placeholderText: placeholder, lineWidth: lineWidth, saveImageLocally: saveImageLocally)
    }
    
}

public struct ColorPickerCompat: View {
    @Binding var selection: Color
    @State private var showPopover = false
    private let availableColors: [Color] = [.blue, .black, .red]
    
    public var body: some View {
        if #available(iOS 14.0, *) {
            ColorPicker(selection:  $selection) {
                EmptyView()
            }
        } else {
            Button(action: {
                showPopover.toggle()
            }, label: {
                colorCircle(selection)
            })
            .popover(isPresented: $showPopover) {
                ForEach(availableColors, id: \.self) { color in
                    Button(action: {
                        selection = color
                        showPopover.toggle()
                    }, label: {
                        colorCircle(color)
                    })
                }
            }
        }
    }
    
    func colorCircle(_ color: Color) -> some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 32, height: 32)
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct SignatureDrawView: View {
    @Environment(\.colorScheme) var colorScheme
    public var onEnded: ((UIImage) -> Void)
    @Binding var drawing: DrawingPath
    @Binding var lineColor: Color
    var placeholderText: Text
    var lineWidth: CGFloat
    var saveImageLocally: Bool
    @State private var drawingBounds: CGRect = .zero
    
    var body: some View {
        ZStack {
            background
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: FramePreferenceKey.self, value: geometry.frame(in: .local))
                })
                .onPreferenceChange(FramePreferenceKey.self) { bounds in
                    drawingBounds = bounds
                }
            if drawing.isEmpty {
                placeholderText
                    .font(.system(size: 44))
                    .opacity(0.2)
            } else {
                DrawShape(drawingPath: drawing)
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(lineColor)
            }
        }
//        .frame(minHeight: .infinity)
        
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged { value in
                    print("\(type(of: self)).\(#function)-drag gesture changed")
                    if drawingBounds.contains(value.location) {
                        drawing.addPoint(value.location)
                    } else {
                        drawing.addBreak()
                    }
                }
                .onEnded { _ in
                    print("\(type(of: self)).\(#function)-drag gesture ended")
                    drawing.addBreak()
                    extractImage()
                }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    print("\(type(of: self)).\(#function)-Tap(drag) gesture ended")
                    let rect = CGRect(origin: value.location, size: CGSize(width: lineWidth, height: lineWidth))
                    drawing.addOval(rect)
                    extractImage()
                }
        )
        
    }
    
    private var background: some View {
        colorScheme == ColorScheme.light ? Color.white : Color.black
    }
    
    private func extractImage() {
        let image: UIImage
        let path = drawing.cgPath
        let maxX = drawing.points.map { $0.x }.max() ?? 0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxX, height: UIScreen.main.bounds.height))
        let uiImage = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(lineColor.uiColor.cgColor)
            ctx.cgContext.setLineWidth(lineWidth)
            ctx.cgContext.beginPath()
            ctx.cgContext.addPath(path)
            ctx.cgContext.drawPath(using: .stroke)
        }
        image = uiImage
        
        if saveImageLocally {
            if let data = image.jpegData(compressionQuality: 1),
               let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filename = docsDir.appendingPathComponent("Signature-\(Date()).png")
                try? data.write(to: filename)
            }
        }
        onEnded(image)
    }
}

struct DrawingPath: Equatable {
    private(set) var points = [CGPoint]()
    private var breaks = [Int]()
    private var rects = [CGRect]()
    
    var isEmpty: Bool {
        points.isEmpty && rects.isEmpty
    }
    
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
    
    mutating func addBreak() {
        breaks.append(points.count)
    }
    
    mutating func addOval(_ oval: CGRect) {
        rects.append(oval)
    }
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for i in 1..<points.count {
            if breaks.contains(i) {
                path.move(to: points[i])
            } else {
                path.addLine(to: points[i])
            }
        }
        
        for rect in rects {
            let oval = CGMutablePath(ellipseIn: rect, transform: nil)
            path.addPath(oval)
        }
        
        return path
    }
    
    var path: Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for i in 1..<points.count {
            if breaks.contains(i) {
                path.move(to: points[i])
            } else {
                path.addLine(to: points[i])
            }
        }
        
        for rect in rects {
            let oval = Path(ellipseIn: rect)
            path.addPath(oval)
        }
        
        return path
    }
    
}

struct DrawShape: Shape {
    let drawingPath: DrawingPath
    
    func path(in rect: CGRect) -> Path {
        drawingPath.path
    }
   
}



// MARK: Extensions
public extension SignatureView {
    
    func clear(action: (() -> Void)? = nil) {
        drawing = DrawingPath()
        image = UIImage()
        isImageSet = false
        action?()
    }
    
}


private extension Color {
    var uiColor: UIColor {
        if #available(iOS 14, *) {
            return UIColor(self)
        } else {
            let components = self.components
            return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
        }
    }
    
    private var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}





// MARK: Preview
struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SignatureView(disableUserInteraction: .constant(false), showColorPicker: true, onClear: nil, onEnded: { image in
                // handle image here
            })
        }
    }
}
