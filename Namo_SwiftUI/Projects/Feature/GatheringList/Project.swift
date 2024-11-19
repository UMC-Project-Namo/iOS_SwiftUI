import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .GatheringList,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .GatheringList,
		factory: .init(
			dependencies: [
				.feature(interface: .GatheringList)
			]
		)
	),
	.feature(
		testing: .GatheringList,
		factory: .init(
			dependencies: [
				.feature(interface: .GatheringList)
			]
		)
	),
	.feature(
		tests: .GatheringList,
		factory: .init(
			dependencies: [
				.feature(testing: .GatheringList)
			]
		)
	),
	.feature(
		example: .GatheringList,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .GatheringList)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.GatheringList.rawValue,
	targets: targets
)



