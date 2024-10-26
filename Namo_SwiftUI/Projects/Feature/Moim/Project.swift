//
//  Project.swift
//  AppManifests
//
//  Created by 권석기 on 9/5/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        interface: .Moim,
        factory: .init(
            dependencies: [
                .domain
            ]
        )
    ),
    .feature(
        implements: .Moim,
        factory: .init(
            dependencies: [
                .feature(interface: .Moim),
                .feature(implements: .Friend),
                .feature(implements: .PlaceSearch)
            ]
        )
    ),
    .feature(
        testing: .Moim,
        factory: .init(
            dependencies: [
                .feature(interface: .Moim)
            ]
        )
    ),
    .feature(
        tests: .Moim,
        factory: .init(
            dependencies: [
                .feature(testing: .Moim)
            ]
        )
    ),
    .feature(
        example: .Moim,
        factory: .init(
            infoPlist: .exampleAppDefault,
            dependencies: [
                .feature(interface: .Moim),
                .feature(implements: .Moim)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Moim.rawValue,
    targets: targets
)


