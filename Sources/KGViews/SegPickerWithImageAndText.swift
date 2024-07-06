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

public struct SegPickerWithImageAndText: View {
    var segments: [Segment]
    @Binding var selected: Int
    
    public init(segments: [Segment], selected: Binding<Int>) {
        self.segments = segments
        _selected = selected
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





// MARK: Preview
struct SegPickerWithImageAndText_Previews: PreviewProvider {
    static var seg1 = Segment(title:  Text("Person"), image:  Image(systemName: "person"), id: 0)
    static var seg2 = Segment(title:  Text("Other"), image:  Image(systemName: "ellipsis.circle"), id: 1)
    
    static var previews: some View {
        SegPickerWithImageAndText(segments: [seg1, seg2], selected: .constant(1))
    }
}
