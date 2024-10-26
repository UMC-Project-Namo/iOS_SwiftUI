import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .PlaceSearch,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .PlaceSearch,
		factory: .init(
			dependencies: [
				.feature(interface: .PlaceSearch)                
			]
		)
	),
	.feature(
		testing: .PlaceSearch,
		factory: .init(
			dependencies: [
				.feature(interface: .PlaceSearch)
			]
		)
	),
	.feature(
		tests: .PlaceSearch,
		factory: .init(
			dependencies: [
				.feature(testing: .PlaceSearch)
			]
		)
	),
	.feature(
		example: .PlaceSearch,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .PlaceSearch),
                .feature(interface: .PlaceSearch)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.PlaceSearch.rawValue,
	targets: targets
)



