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
		interface: .Friend,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .Friend,
		factory: .init(
			dependencies: [
				.feature(interface: .Friend),
				.feature(implements: .Calendar)
			]
		)
	),
	.feature(
		testing: .Friend,
		factory: .init(
			dependencies: [
				.feature(interface: .Friend)
			]
		)
	),
	.feature(
		tests: .Friend,
		factory: .init(
			dependencies: [
				.feature(testing: .Friend)
			]
		)
	),
	.feature(
		example: .Friend,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Friend)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.Friend.rawValue,
	targets: targets
)
