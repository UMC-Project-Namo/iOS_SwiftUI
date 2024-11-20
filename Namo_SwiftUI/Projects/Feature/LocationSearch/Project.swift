import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .LocationSearch,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .LocationSearch,
		factory: .init(
			dependencies: [
				.feature(interface: .LocationSearch)
			]
		)
	),
	.feature(
		testing: .LocationSearch,
		factory: .init(
			dependencies: [
				.feature(interface: .LocationSearch)
			]
		)
	),
	.feature(
		tests: .LocationSearch,
		factory: .init(
			dependencies: [
				.feature(testing: .LocationSearch)
			]
		)
	),
	.feature(
		example: .LocationSearch,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .LocationSearch)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.LocationSearch.rawValue,
	targets: targets
)



