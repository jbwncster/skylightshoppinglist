// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkylightShoppingList",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SkylightShoppingList",
            targets: ["SkylightShoppingList"]
        ),
    ],
    dependencies: [
        // Official OpenFoodFacts Swift SDK
        .package(
            url: "https://github.com/openfoodfacts/openfoodfacts-swift.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "SkylightShoppingList",
            dependencies: [
                .product(name: "OpenFoodFacts", package: "openfoodfacts-swift")
            ]
        ),
        .testTarget(
            name: "SkylightShoppingListTests",
            dependencies: ["SkylightShoppingList"]
        ),
    ]
)
