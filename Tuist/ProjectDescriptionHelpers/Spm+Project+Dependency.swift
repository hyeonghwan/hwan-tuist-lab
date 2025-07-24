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
    static let alamofire: TargetDependency = .external(name: "Alamofire")
}

public enum R {
    public static let kingfisher: Package = .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: Version(8, 4, 0)))
    public static let hwanKit: Package = .package(url: "https://github.com/hyeonghwan/hwan-kit", .revision("d89cc1648a007c5ae9077ae7e5cbbeccff0a8675"))
    public static let hwanMacros: Package = .package(url: "https://github.com/hyeonghwan/hwan_macro", .revision("270ac9b6c28c552e9d02ccf9ec6bf204d77633f4"))
    public static let alamofire: Package = .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: Version(5, 10, 0)))
}

public enum P {
    public static let travelApp: Path = .relativeToRoot("Projects/Travel")
    public static let upDownApp: Path = .relativeToRoot("Projects/UpDown")
    public static let networkSample: Path = .relativeToRoot("Projects/NetworkSample")
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
    
    static let networkSample = TargetDependency.project(
        target: "NetworkSample",
        path: P.networkSample
    )
}

