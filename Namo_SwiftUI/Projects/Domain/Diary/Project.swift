import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .Diary,
        factory: .init(
            dependencies: [
                .core
            ]
        )
    ),
    .domain(
        implements: .Diary,
        factory: .init(
            dependencies: [
                .domain(interface: .Diary)
            ]
        )
    ),
    .domain(
        testing: .Diary,
        factory: .init(
            dependencies: [
                .domain(interface: .Diary)
            ]
        )
    ),
    .domain(
        tests: .Diary,
        factory: .init(
            dependencies: [
                .domain(testing: .Diary)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Diary.rawValue,
    targets: targets
)



