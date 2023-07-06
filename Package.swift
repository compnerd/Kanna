// swift-tools-version:5.2

import PackageDescription

// Starting with Xcode 12, we don't need to depend on our own libxml2 target
#if swift(>=5.3) && os(macOS)
let dependencies: [Target.Dependency] = []
#else
let dependencies: [Target.Dependency] = ["libxml2"]
#endif

#if swift(>=5.2) && (os(macOS) || os(Windows))
let pkgConfig: String? = nil
#else
let pkgConfig = "libxml-2.0"
#endif

#if swift(>=5.2)
let provider: [SystemPackageProvider] = [
    .apt(["libxml2-dev"])
]
#else
let provider: [SystemPackageProvider] = [
    .apt(["libxml2-dev"]),
    .brew(["libxml2"])
]
#endif

let package = Package(
    name: "Kanna",
    products: [
      .library(name: "Kanna", targets: ["Kanna"])
    ],
    targets: [
        .systemLibrary(
            name: "libxml2",
            path: "Modules",
            pkgConfig: pkgConfig,
            providers: provider
        ),
        .target(
            name: "Kanna",
            dependencies: dependencies,
            path: "Sources",
            exclude: [
                "Kanna/Info.plist",
                "Kanna/Kanna.h",
                "../Tests/KannaTests/Data"
            ],
            cSettings: [.define("LIBXML_STATIC", .when(platforms: [.windows]))],
            linkerSettings: [
                .linkedLibrary("xml2", .when(platforms: [.linux])),
                .linkedLibrary("libxml2s", .when(platforms: [.windows])),
            ]
        ),
        .testTarget(
            name: "KannaTests",
            dependencies: ["Kanna"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
