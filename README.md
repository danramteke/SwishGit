# Swish Git

Git plugin for Swish

Swish is a tool for running command line tools from Swift programs. Find out more about Swish from https://github.com/danramteke/swish

## Example


### Example usage

    import SwishGit
    
    let git = Git()
    
    // check if repo is clean
    guard git.isClean() else {
      print("git repo is not clean")
      return
    }

    let root = try git.root() // Fetch the root of the git repo
    
    // ...
    // do something with the git root
    // such as load an asset or
    // run a script
    

### Example `Package.swift`

    // swift-tools-version:5.6

    import PackageDescription

    let package = Package(
        name: "Scripts",
        platforms: [.macOS(.v12)],
        dependencies: [
          .package(url: "https://github.com/danramteke/swish.git", from: "1.4.0"),
          .package(url: "https://github.com/danramteke/swish-git.git", from: "0.1.0"),
        ],
        targets: [
            .executableTarget(
                name: "sample-script",
                dependencies: [
                    .product(name: "SwishKit", package: "Swish"),
                    .product(name: "SwishGit", package: "swish-git"),
                ]),
        ]
    )

