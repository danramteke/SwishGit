// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SwishGit",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .library(name: "SwishGit", targets: ["SwishGit"])
  ],
  dependencies: [
    .package(url: "https://github.com/danramteke/Swish.git", from: "2.0.0"),
  ],
  targets: [
    .target(name: "SwishGit", dependencies: [
      "Swish"
    ]),
    .testTarget(name: "SwishGitTests", dependencies: [
      "SwishGit", "Swish"
    ]),
  ]
)
