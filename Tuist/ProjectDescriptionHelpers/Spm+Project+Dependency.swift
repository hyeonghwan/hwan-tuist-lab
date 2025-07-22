import ProjectDescription

public extension TargetDependency {
    enum PRO {}
    enum MOD {}
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let hwanKit: TargetDependency = .external(name: "HwanKit")
    static let hwanMacros: TargetDependency = .external(name: "HwanMacros")
}

public enum R {
    public static let kingfisher: Package = .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: Version(8, 4, 0)))
    public static let hwanKit: Package = .package(url: "https://github.com/hyeonghwan/hwan-kit", .branch("main"))
    public static let hwanMacros: Package = .package(url: "https://github.com/hyeonghwan/hwan_macro", .branch("main"))
}

public enum P {
    public static let travelApp: Path = .relativeToRoot("Projects/Travel")
    public static let upDownApp: Path = .relativeToRoot("Projects/UpDown")
}

public extension TargetDependency.PRO {
    static let travel = TargetDependency.project(
        target: "Travel",
        path: P.travelApp
    )
    static let upDown = TargetDependency.project(
        target: "UpDown",
        path: P.upDownApp
    )
}

