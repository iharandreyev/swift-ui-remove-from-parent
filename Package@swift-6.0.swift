// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "OnRemoveFromParent",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "OnRemoveFromParent",
      targets: [
        "OnRemoveFromParent",
      ]
    ),
  ],
  targets: [
    .target(
      name: "OnRemoveFromParent"
    ),
    .testTarget(
      name: "OnRemoveFromParentTests",
      dependencies: [
        "OnRemoveFromParent",
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
