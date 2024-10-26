//
//  Project.swift
//  AppManifests
//
//  Created by 정현우 on 8/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		factory: .init(
			dependencies: [
				.domain,
				.feature(implements: .Friend),
				.feature(implements: .Category),
				.feature(implements: .Home),
                .feature(implements: .Moim),
                .feature(implements: .Onboarding),
				.feature(implements: .Calendar),
                .feature(implements: .PlaceSearch)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name,
	targets: targets
)
