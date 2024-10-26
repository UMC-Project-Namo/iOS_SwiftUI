//
//  ScheduleEndPoint.swift
//  Namo_SwiftUI
//
//  Created by 정현우 on 2/5/24.
//

import Alamofire

import SharedUtil

public enum ScheduleEndPoint {
	// 개인 캘린더 조회
	case getSchedule(startDate: String, endDate: String)
	// 개인 일정 내용 수정
	case updateSchedule(scheduleId: Int, schedule: ScheduleEditDTO)
	// 개인 일정 생성
	case createSchedule(schedule: ScheduleEditDTO)
	// 개인 일정 삭제
	case deleteSchedule(scheduleId: Int)
}

extension ScheduleEndPoint: EndPoint {
	public var baseURL: String {
		return "\(SecretConstants.baseURL)/schedules"
	}
	
	public var path: String {
		switch self {
		case .getSchedule:
			return "/calendar"
		case .updateSchedule(let scheduleId, _):
			return "/\(scheduleId)"
		case .createSchedule(_):
			return ""
		case .deleteSchedule(let scheduleId):
			return "/\(scheduleId)"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
		case .getSchedule:
			return .get
		case .updateSchedule:
			return .patch
		case .createSchedule:
			return .post
		case .deleteSchedule:
			return .delete
		}
	}
	
	public var task: APITask {
        switch self {
		case let .getSchedule(startDate, endDate):
			let parameters: [String: Any] = [
				"startDate": startDate,
				"endDate": endDate
			]
			return .requestParameters(
				parameters: parameters,
				encoding: URLEncoding.default
			)
		case .updateSchedule(_, let schedule):
			return .requestJSONEncodable(parameters: schedule)
		case .createSchedule(let schedule):
			return .requestJSONEncodable(parameters: schedule)
		case .deleteSchedule:
			return .requestPlain
		}
	}
	
	
}
