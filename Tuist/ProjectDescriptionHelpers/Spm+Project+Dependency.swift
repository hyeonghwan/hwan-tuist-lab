import ProjectDescription

public extension TargetDependency {
    enum PRO {}
    enum MOD {}
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let hwanKit: TargetDependency    = .external(name: "HwanKit")
    static let alamofire: TargetDependency  = .external(name: "Alamofire")
    static let combineInterception: TargetDependency  = .external(name: "CombineInterception")
    static let kingfisherPackage: TargetDependency = .package(product: "Kingfisher", type: .runtime)
    static let hwanKitPackage: TargetDependency    = .package(product: "HwanKit", type: .runtime)
    static let alamofirePackage: TargetDependency  = .package(product: "Alamofire", type: .runtime)
    static let hwanMacrosPackage: TargetDependency = .package(product: "HwanMacros", type: .macro)
}

public enum R {
    public static let kingfisher: Package = .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: Version(8, 4, 0)))
    
    public static let hwanKit: Package = .package(url: "https://github.com/hyeonghwan/hwan-kit.git", .revision("60ee5fe416b71534e97761327ed975682511e77c"))
    
    public static let hwanMacros: Package = .local(path: .relativeToRoot("Module/hwan_macro"))
    
    public static let alamofire: Package = .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: Version(5, 10, 0)))
    
    public static let combineInterception: Package = .package(url: "https://github.com/chorim/CombineInterception.git", .upToNextMajor(from: Version(0, 1, 0)))
}

public enum P {
    public static let travelApp: Path = .relativeToRoot("Projects/Travel")
    public static let upDownApp: Path = .relativeToRoot("Projects/UpDown")
    public static let networkSample: Path = .relativeToRoot("Projects/NetworkSample")
    public static let mbtiApp: Path = .relativeToRoot("Projects/MBTI")
    public static let photoFeature: Path = .relativeToRoot("Projects/PhotoFeature")
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
    
    static let photoFeature = TargetDependency.project(
        target: "PhotoFeature",
        path: P.photoFeature
    )
}

