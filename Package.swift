// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KGViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KGViews",
            targets: ["KGViews"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//         .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/kevingreen22/Biometrics.git", from: "1.0.0"),
        .package(url: "https://github.com/kevingreen22/HapticManager.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KGViews",
            dependencies: [
                .product(name: "Biometrics", package: "Biometrics"),
                .product(name: "HapticManager", package: "HapticManager")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "KGViewsTests",
            dependencies: ["KGViews"]),
    ]
)



//extension Image {
//    init(packageResource name: String, ofType type: String) {
//        #if canImport(UIKit)
//        guard let path = Bundle.module.path(forResource: name, ofType: type),
//              let image = UIImage(contentsOfFile: path) else {
//            self.init(name)
//            return
//        }
//        self.init(uiImage: image)
//        #elseif canImport(AppKit)
//        guard let path = Bundle.module.path(forResource: name, ofType: type),
//              let image = NSImage(contentsOfFile: path) else {
//            self.init(name)
//            return
//        }
//        self.init(nsImage: image)
//        #else
//        self.init(name)
//        #endif
//    }
//}
