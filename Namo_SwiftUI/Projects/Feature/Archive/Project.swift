import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .Archive,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .Archive,
		factory: .init(
			dependencies: [
				.feature(interface: .Archive),
				.feature(interface: .Calendar)
			]
		)
	),
	.feature(
		testing: .Archive,
		factory: .init(
			dependencies: [
				.feature(interface: .Archive)
			]
		)
	),
	.feature(
		tests: .Archive,
		factory: .init(
			dependencies: [
				.feature(testing: .Archive)
			]
		)
	),
	.feature(
		example: .Archive,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Archive)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.Archive.rawValue,
	targets: targets
)



