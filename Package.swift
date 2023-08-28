// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSignInWith3rd+Apple",
    platforms: [.iOS(.v14)],
    products: [.library(name: "WWSignInWith3rd+Apple", targets: ["WWSignInWith3rd+Apple"]),],
    dependencies: [],
    targets: [.target(name: "WWSignInWith3rd+Apple", dependencies: []),],
    swiftLanguageVersions: [.v5]
)
