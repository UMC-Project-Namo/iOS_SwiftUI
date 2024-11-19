import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .FriendInvite,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .FriendInvite,
		factory: .init(
			dependencies: [
				.feature(interface: .FriendInvite)
			]
		)
	),
	.feature(
		testing: .FriendInvite,
		factory: .init(
			dependencies: [
				.feature(interface: .FriendInvite)
			]
		)
	),
	.feature(
		tests: .FriendInvite,
		factory: .init(
			dependencies: [
				.feature(testing: .FriendInvite)
			]
		)
	),
	.feature(
		example: .FriendInvite,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .FriendInvite)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.FriendInvite.rawValue,
	targets: targets
)



