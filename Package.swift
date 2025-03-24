// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSignInWith3rd_Apple",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWSignInWith3rd_Apple", targets: ["WWSignInWith3rd_Apple"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWSignInWith3rd_Apple", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
