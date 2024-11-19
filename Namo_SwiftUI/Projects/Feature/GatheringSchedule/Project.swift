import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .GatheringSchedule,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .GatheringSchedule,
		factory: .init(
			dependencies: [
				.feature(interface: .GatheringSchedule),
                .feature(interface: .KakaoMap),
                .feature(interface: .FriendInvite)
			]
		)
	),
	.feature(
		testing: .GatheringSchedule,
		factory: .init(
			dependencies: [
				.feature(interface: .GatheringSchedule)
			]
		)
	),
	.feature(
		tests: .GatheringSchedule,
		factory: .init(
			dependencies: [
				.feature(testing: .GatheringSchedule)
			]
		)
	),
	.feature(
		example: .GatheringSchedule,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .GatheringSchedule)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.GatheringSchedule.rawValue,
	targets: targets
)



