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
		interface: .Friend,
		factory: .init(
			dependencies: [
				.core,
				.domain(implements: .Schedule)
			]
		)
	),
	.domain(
		implements: .Friend,
		factory: .init(
			dependencies: [
				.domain(interface: .Friend)
			]
		)
	),
	.domain(
		testing: .Friend,
		factory: .init(
			dependencies: [
				.domain(interface: .Friend)
			]
		)
	),
	.domain(
		tests: .Friend,
		factory: .init(
			dependencies: [
				.domain(testing: .Friend)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Domain.name+ModulePath.Domain.Friend.rawValue,
	targets: targets
)
