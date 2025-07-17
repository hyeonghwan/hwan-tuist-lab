import ProjectDescription

public extension TargetDependency {
    enum PRO {}
    enum MOD {}
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
}

public enum P {
    public static let travelApp: Path = .relativeToRoot("Projects/Travel")
}

public extension TargetDependency.PRO {
    static let travel = TargetDependency.project(
        target: "Travel",
        path: P.travelApp
    )
}

