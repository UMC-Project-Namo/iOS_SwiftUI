//
//  CalendarFriendSchedule.swift
//  DomainFriend
//
//  Created by 정현우 on 10/26/24.
//

import Foundation

public struct CalendarFriendSchedule: Hashable {
	public init(position: Int, schedule: FriendSchedule?) {
		self.position = position
		self.schedule = schedule
	}
	
	public let position: Int
	public let schedule: FriendSchedule?
}
