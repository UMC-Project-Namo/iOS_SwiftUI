//
//  ScheduleEditDTO.swift
//  CoreNetwork
//
//  Created by 정현우 on 10/21/24.
//

import Foundation

public struct ScheduleEditDTO: Encodable {
	public var title: String
	public var categoryId: Int
	public var period: SchedulePeriodDTO
	public var location: ScheduleLocationDTO?
	public var reminderTrigger: [String]?
	
	public init(
		title: String = "",
		categoryId: Int = -1,
		period: SchedulePeriodDTO,
		location: ScheduleLocationDTO? = nil,
		reminderTrigger: [String]? = nil
	) {
		self.title = title
		self.categoryId = categoryId
		self.period = period
		self.location = location
		self.reminderTrigger = reminderTrigger
	}
	enum CodingKeys: String, CodingKey {
		   case title, categoryId, period, location, reminderTrigger
	   }
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		// 기본 값 인코딩
		try container.encode(title, forKey: .title)
		try container.encode(categoryId, forKey: .categoryId)
		try container.encode(period, forKey: .period)
		try container.encode(reminderTrigger, forKey: .reminderTrigger)
		
		// location이 nil이면 명시적으로 null 인코딩
		if let location = location {
			try container.encode(location, forKey: .location)
		} else {
			try container.encodeNil(forKey: .location)
		}
	}
	
	
}

public struct SchedulePeriodDTO: Encodable  {
	public var startDate: String
	public var endDate: String
	
	public init(
		startDate: String,
		endDate: String
	) {
		self.startDate = startDate
		self.endDate = endDate
	}
}
