[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

# KGViews

A collection of SwiftUI views for some slightly advanced visuals and ease of usage.

If you like the project, please do not forget to `star ★` this repository and follow me on GitHub.


## 📦 Requirements

- iOS 15.0+
- macOS 13.0+
- Xcode 13.0+
- Swift 5.0


## Installation 

To install the component add it to your project using Swift Package Manager with url below.

```
https://github.com/kevingreen22/KGViews
```

Import the package.

```swift
import KGViews
```


## Table of Contents

- [Bar Sliders](#bar-sliders)
- [Button Loaders & Styles](#button=-loader-and-styles)
- [Close Button](#close-button)
- [Image with Default](#image-with-default)
- [Segmented Picker with Images](#segmented=picker-with-images)
- [Real Blur](#real-blur)
- [Rounded Corner](#rounded-corner)
- [Search Bar](#search-bar)
- [Signature View](#signature-view)
- [Smart Async Image](#smart-async-image)
- [Smooth Drag](#smooth-drag)
- [Specialty Text Fields](#specialty-text-fields)
- [Sticky Header](#sticky-header)
- [Triangle with Rounded Corners](#triangle-rounded-corners)



### Bar Sliders
![Sliders Screenshot](https://github.com/kevingreen22/KGViews/tree//developer/readMe_resources/bar_sliders.gif)
#### Example

```swift
VSlider(value: $valueV, minValue: 0, maxValue: 1)
    .frame(width: 80, height: 200)
        
HSlider(value: $valueH, minValue: 0, maxValue: 1)
    .frame(width: 360, height: 80)
```


### Button Loaders & Styles
![Button Loaders & Styles Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/button_loader_and_styles.gif)

#### Example
Can be used as a modifier or a view. They have slightly different visuals.

```swift
Button {
    // action goes here
} label: {
    Text("Button using modifier")
}
.withLoader($showLoader) <-- modifier here

// OR

ButtonWithLoader {
    // action goes here
} label: {
    Text("Button as View")
}
```


### Close Button
![Close Button Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/close_button.gif)

#### Example
Can be used as a modifier or a view. Will also automatically dismiss a presented view via PresentationMode / Dismiss(). A closure is provided, eg. to toggle a bool, etc.

```swift
Text("Close button")
    .frame(width: 300, height: 300)
    .background { Color.red }
    .closeButton()
    
    // OR

    CloseButton(iconName: "xmark", withBackground: true) {
        // do stuff here.
    }
```


### Image with Default
<img src='https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/image_with_default.png' height="625">

#### Example

```swift
Image(uiimage: nil, systemName: "paintpalette.fill")

// OR...

Image(uiimage: nil) <-- Most likely you'll use an optional image here (i.e. UIImage)

```


### Segmented Picker with Images
![Segmented Picker with Images Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/segmented_with_image.gif)

#### Example
Shown here in a full struct as to show the state variable and the initialization of the segments.

```swift
struct ExampleView: View {
    @State private var selected = 0
    
    var body: some View {
        let seg1 = Segment(title:  Text("Person"), image:  Image(systemName: "person"), id: 0)
        let seg2 = Segment(title:  Text("Other"), image:  Image(systemName: "ellipsis.circle"), id: 1)

        return PickerSegmentedImage(selected: $selected, segments: [seg1, seg2])
    }
}
```


### Real Blur
<!--![Real Blur Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/real_blur.png){: width="50%"} -->
<img src='https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/real_blur.png' height="625">

#### Example
This example offsets & frames the blur view so it is easier to visualize.

```swift
ZStack {
    Color.green.ignoresSafeArea()
    Image(systemName: "person.fill")
        .scaleEffect(5)
    RealBlur(style: .regular)
        .frame(width: 100, height: 100)
        .offset(x: 50)
}
```


### Rounded Corner
![Rounded Corner Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/rounded_corner.png)

#### Example
Can be used as a modifier or as a view.

```swift
VStack {
    Rectangle()
    .roundCorner(.bottomRight, radius: 30) <-- as a modifier
    .foregroundStyle(Color.red)
    .frame(width: 100, height: 100)

    // OR AS A VIEW

    KGRoundedCorner(corners: .bottomLeft, radius: 10)
        .fill(Color.orange)
        .frame(width: 100, height: 100)
}

```


### Search Bar
![Search Bar Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/search_bar.gif)

#### Example
The search bar has been added in to a navigation view for a better visual.

```swift
NavigationView {
    ScrollView {
        VStack(alignment: .leading) {
            SearchBar(searchText: $searchText)
                .padding(.horizontal)
        }
    }
    .navigationTitle("Search")
}
.navigationViewStyle(.stack)
```


### Signature View

| Landscape | Portrait |
|-|-|
| ![Signature View Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/signature_view_landscape.gif) | ![Signature View Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/signature_view_portrait.gif) |

#### Example
The SignatureView can also be embedded into any stack/container.

```swift
SignatureView(disableUserInteraction: .constant(false), showColorPicker: true, onClear: nil, onEnded: { image in
    // handle image here
})

```


### Smart Async Image
![Smart Async Image Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/smart-async-image.gif)

#### Example
Self explanitory. The url here is just for example sake. It fetches a random photo from an API to show the purpose of the what the view is doing.

```swift
SmartAsyncImage(urlString: "https://picsum.photos/200")
```



### Smooth Drag
![Smooth Drag Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/smooth-drag.gif)

#### Example
This drag gesture uses the .update method of DragGesture to create a smooth drag feel without a laggy or jumpy effect. Should be accompanied with a state variable & an offset modifier as all gestures need.

```swift
Rectangle()
    .fill(Color.indigo)
    .frame(width: 100, height: 100)
    .offset(location)
    .gesture(SmoothDrag(location: $location))
```


### Specialty Text Fields
![Specialty Text Fields Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/text_fields.png)

#### Example
This API contains TextFieldStyles for pure customization, along with a "visual validate" method. This method not only validates the text in the field, but it also visually shows whether-or-not it is a valid-input in real time.
 
```swift
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
```


### Sticky Header
![Sticky Header Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/sticky_header.gif)

#### Example
Just another sticky header image that scales when scrolled.

```swift
    ScrollView(showsIndicators: false) {
        StickyHeader {
            Image(packageResource: "sticky_header", ofType: ".png")
                .resizable()
                .scaledToFill()
        }
        .frame(height: 100)
    }
    .background {
        Color.orange.ignoresSafeArea()
    }
```


### Triangle with Rounded Corners
![Triangle with Rounded Corners Screenshot](https://github.com/kevingreen22/KGViews/blob/developer/readMe_resources/triangle_rounded_corners.gif)

#### Example
A triangle shape (missing from SwiftUI's shapes API). Initializers for optional rounded corners, either all or individually. As well as a corner radius.

```swift
Triangle()
    .fill(Color.indigo)
    .frame(width: 300, height: 300)

// OR

Triangle(cornerRadius: 20, on: corners!)
    .fill(Color.indigo)
    .frame(width: 300, height: 300)

```
