//
//  Project.swift
//  AppManifests
//
//  Created by 정현우 on 8/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.feature(
		factory: .init(
			dependencies: [
				.domain,
				.feature(implements: .Friend),
				.feature(implements: .Category),
				.feature(implements: .Home),
                .feature(implements: .Onboarding),
				.feature(implements: .Calendar),                
				.feature(implements: .Archive),
                .feature(implements: .GroupList),
                .feature(implements: .GatheringSchedule),
                .feature(implements: .GatheringList),
                .feature(implements: .FriendInvite),
                .feature(implements: .KakaoMap),
                .feature(implements: .LocationSearch),
			]
		)
	)
]

let project: Project = .makeModule(
	name: ModulePath.Feature.name,
	targets: targets
)
