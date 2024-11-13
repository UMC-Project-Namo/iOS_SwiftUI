//
//  Project.swift
//  Manifests
//
//  Created by 정현우 on 9/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .Home,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .Home,
		factory: .init(
			dependencies: [
				.feature(interface: .Home),
				.feature(implements: .Calendar),
				.feature(implements: .Archive)
			]
		)
	),
	.feature(
		testing: .Home,
		factory: .init(
			dependencies: [
				.feature(interface: .Home)
			]
		)
	),
	.feature(
		tests: .Home,
		factory: .init(
			dependencies: [
				.feature(testing: .Home)
			]
		)
	),
	.feature(
		example: .Home,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Home)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.Home.rawValue,
	targets: targets
)


