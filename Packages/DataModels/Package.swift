// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DataModels",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "DataModels",
      targets: ["DataModels"]
    ),
  ],
  dependencies: [
    .package(name: "ValidationKit", path: "../ValidationKit"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "DataModels",
      dependencies: [
        .product(name: "ValidationKit", package: "ValidationKit"),
      ],
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ]
    ),
    .testTarget(
      name: "DataModelsTests",
      dependencies: ["DataModels"]
    ),
  ]
)
