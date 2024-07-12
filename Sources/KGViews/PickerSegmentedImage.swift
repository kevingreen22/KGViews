//
//  SegPickerWithImageAndText.swift
//
//  Created by Kevin Green on 8/19/22.
//

import SwiftUI

public struct Segment: Identifiable {
    public var title: Text
    public var image: Image
    public var id: Int
    
    public init(title: Text, image: Image, id: Int) {
        self.title = title
        self.image = image
        self.id = id
    }
}

/// A simplistic implementation of a Segmented Picker that allows for images and text in the segment.
public struct PickerSegmentedImage: View {
    @Binding var selected: Int
    var segments: [Segment]

    
    public init(selected: Binding<Int>, segments: [Segment]) {
        _selected = selected
        self.segments = segments
    }
    
    public var body: some View {
        HStack(spacing: 0){
            ForEach(segments) { segment in
                segmentView(segment)
            }            
        }
        .padding(3)
        .background(Color(uiColor: .black).opacity(0.06))
        .clipShape(Capsule())
    }
    
    public func segmentView(_ segment: Segment) -> some View {
        HStack {
            segment.image
                .foregroundColor(self.selected == segment.id ? Color(uiColor: .black) : Color(uiColor: .gray))
            segment.title
                .foregroundColor(self.selected == segment.id ? Color(uiColor: .black) : Color(uiColor: .gray))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 35)
        .background(Color(uiColor: .white).opacity(self.selected == segment.id ? 1.0 : 0.0))
        .clipShape(Capsule())
        .onTapGesture {
            withAnimation(.easeInOut) {
                self.selected = segment.id
            }
        }
    }
    
}


// MARK: Picker Segmented Image Demo
fileprivate struct PickerSegmentedImage_DemoView: View {
    @State var selected = 0
    var body: some View {
        let seg1 = Segment(title:  Text("Person"), image:  Image(systemName: "person"), id: 0)
        let seg2 = Segment(title:  Text("Other"), image:  Image(systemName: "ellipsis.circle"), id: 1)
        
        return PickerSegmentedImage(selected: $selected, segments: [seg1, seg2])
    }
}

fileprivate struct PickerSegmentedImage_Demo: PreviewProvider {
    static var previews: some View {
        PickerSegmentedImage_DemoView()
    }
}

#Preview {
    PickerSegmentedImage_DemoView()
}

