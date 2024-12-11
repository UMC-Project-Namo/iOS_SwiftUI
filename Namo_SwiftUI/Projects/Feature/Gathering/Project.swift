import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .Gathering,
		factory: .init(
			dependencies: [
				.domain,
                .feature(interface: .FriendInvite),
                .feature(interface: .LocationSearch),
			]
		)
	),
	.feature(
		implements: .Gathering,
		factory: .init(
			dependencies: [
				.feature(interface: .Gathering),
                .feature(interface: .FriendInvite),
                .feature(interface: .LocationSearch),
			]
		)
	),
	.feature(
		testing: .Gathering,
		factory: .init(
			dependencies: [
				.feature(interface: .Gathering)
			]
		)
	),
	.feature(
		tests: .Gathering,
		factory: .init(
			dependencies: [
				.feature(testing: .Gathering)
			]
		)
	),
	.feature(
		example: .Gathering,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .Gathering)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.Gathering.rawValue,
	targets: targets
)



