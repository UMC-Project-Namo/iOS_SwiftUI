import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .PlaceSearch,
        factory: .init(
            dependencies: [
                .core
            ]
        )
    ),
    .domain(
        implements: .PlaceSearch,
        factory: .init(
            dependencies: [
                .domain(interface: .PlaceSearch)
            ]
        )
    ),
    .domain(
        testing: .PlaceSearch,
        factory: .init(
            dependencies: [
                .domain(interface: .PlaceSearch)
            ]
        )
    ),
    .domain(
        tests: .PlaceSearch,
        factory: .init(
            dependencies: [
                .domain(testing: .PlaceSearch)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.PlaceSearch.rawValue,
    targets: targets
)



