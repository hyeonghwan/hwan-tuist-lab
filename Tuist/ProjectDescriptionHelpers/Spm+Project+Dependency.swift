import ProjectDescription

public extension TargetDependency {
    enum PRO {}
    enum MOD {}
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
}

public enum R {
    public static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: Version(8, 4, 0)))
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

