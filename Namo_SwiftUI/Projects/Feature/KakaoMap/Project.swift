import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		interface: .KakaoMap,
		factory: .init(
			dependencies: [
				.domain
			]
		)
	),
	.feature(
		implements: .KakaoMap,
		factory: .init(
			dependencies: [
				.feature(interface: .KakaoMap)
			]
		)
	),
	.feature(
		testing: .KakaoMap,
		factory: .init(
			dependencies: [
				.feature(interface: .KakaoMap)
			]
		)
	),
	.feature(
		tests: .KakaoMap,
		factory: .init(
			dependencies: [
				.feature(testing: .KakaoMap)
			]
		)
	),
	.feature(
		example: .KakaoMap,
		factory: .init(
			infoPlist: .exampleAppDefault,
			dependencies: [
				.feature(implements: .KakaoMap)
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name+ModulePath.Feature.KakaoMap.rawValue,
	targets: targets
)



