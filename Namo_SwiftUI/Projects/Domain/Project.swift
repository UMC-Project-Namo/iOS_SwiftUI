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
	.domain(
		factory: .init(
			dependencies: [
				.core,
				.domain(implements: .Friend),
				.domain(implements: .Category),
				.domain(implements: .Schedule),
                .domain(implements: .Moim),
                .domain(implements: .Auth),
                .domain(implements: .PlaceSearch),
			]
		)
	)
]

let project: Project = .makeModule(
	name: "Domain",
	targets: targets
)
