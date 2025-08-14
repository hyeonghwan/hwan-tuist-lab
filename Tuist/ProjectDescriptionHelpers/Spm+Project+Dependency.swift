import ProjectDescription

public extension TargetDependency {
    enum PRO {}
    enum MOD {}
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let hwanKit: TargetDependency    = .external(name: "HwanKit")
    static let hwanMacros: TargetDependency = .package(product: "HwanMacros", type: .macro)
    static let alamofire: TargetDependency  = .external(name: "Alamofire")
    static let combineInterception: TargetDependency  = .external(name: "CombineInterception")
}

public enum R {
    public static let kingfisher: Package = .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: Version(8, 4, 0)))
    public static let hwanKit: Package = .package(url: "https://github.com/hyeonghwan/hwan-kit.git", .revision("c6d72ec4ed5fafda3a914503737e520ee213b873"))
    public static let hwanMacros: Package = .local(path: .relativeToRoot("Module/hwan_macro"))
    public static let alamofire: Package = .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: Version(5, 10, 0)))
    public static let combineInterception: Package = .package(url: "https://github.com/chorim/CombineInterception.git", .upToNextMajor(from: Version(0, 1, 0)))
    
    // MARK: Remote -> Local
    // public static let hwanMacros: Package = .package(url: "https://github.com/hyeonghwan/hwan_macro.git", .revision("4b756f3f90f71adb4e0f65f1466f0854c250d7d4"))
}

public enum P {
    public static let travelApp: Path = .relativeToRoot("Projects/Travel")
    public static let upDownApp: Path = .relativeToRoot("Projects/UpDown")
    public static let networkSample: Path = .relativeToRoot("Projects/NetworkSample")
    public static let mbtiApp: Path = .relativeToRoot("Projects/MBTI")
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
    
    static let mbtiApp = TargetDependency.project(
        target: "MBTI",
        path: P.mbtiApp
    )
}

