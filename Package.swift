// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Swish Git Plugin",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .library(name: "SwishGit", targets: ["SwishGit"])
  ],
  dependencies: [
    .package(url: "https://github.com/danramteke/Swish.git", from: "1.4.0"),
  ],
  targets: [
    .target(name: "SwishGit", dependencies: [
      .product(name: "SwishKit", package: "Swish")
    ]),
    .testTarget(name: "SwishGitTests", dependencies: [
      .target(name: "SwishGit"),
      .product(name: "SwishKit", package: "Swish"),
    ]),
  ]
)
