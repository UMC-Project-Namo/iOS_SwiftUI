import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .GroupTab,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .GroupTab,
		factory: .init(
			dependencies: [
				.feature(interface: .GroupTab),
                .feature(interface: .Friend),
                .feature(interface: .Gathering)
			]
		)
	),
	.feature(
		testing: .GroupTab,
		factory: .init(
			dependencies: [
				.feature(interface: .Gathering)
			]
		)
	),
	.feature(
		tests: .GroupTab,
		factory: .init(
			dependencies: [
				.feature(testing: .Gathering)
			]
		)
	),
	.feature(
		example: .GroupTab,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Gathering)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.GroupTab.rawValue,
	targets: targets
)



