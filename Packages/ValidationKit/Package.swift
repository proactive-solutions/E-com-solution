// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ValidationKit",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "ValidationKit",
      targets: ["ValidationKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", .upToNextMajor(from: "4.1.0")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "ValidationKit",
      dependencies: [
        .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
      ]),
    .testTarget(
      name: "ValidationKitTests",
      dependencies: ["ValidationKit"]),
  ])
