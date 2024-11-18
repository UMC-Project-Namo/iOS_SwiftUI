import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .Activity,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .Activity,
		factory: .init(
			dependencies: [
				.feature(interface: .Activity)
			]
		)
	),
	.feature(
		testing: .Activity,
		factory: .init(
			dependencies: [
				.feature(interface: .Activity)
			]
		)
	),
	.feature(
		tests: .Activity,
		factory: .init(
			dependencies: [
				.feature(testing: .Activity)
			]
		)
	),
	.feature(
		example: .Activity,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Activity)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.Activity.rawValue,
	targets: targets
)



