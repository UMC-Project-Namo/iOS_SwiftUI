import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .GroupList,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .GroupList,
		factory: .init(
			dependencies: [
				.feature(interface: .GroupList),
                .feature(interface: .Friend),
                .feature(interface: .GatheringList),
                .feature(interface: .GatheringSchedule)
			]
		)
	),
	.feature(
		testing: .GroupList,
		factory: .init(
			dependencies: [
				.feature(interface: .GroupList)
			]
		)
	),
	.feature(
		tests: .GroupList,
		factory: .init(
			dependencies: [
				.feature(testing: .GroupList)
			]
		)
	),
	.feature(
		example: .GroupList,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .GroupList)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.GroupList.rawValue,
	targets: targets
)



