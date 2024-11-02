//
//  DiaryEndPoint.swift
//  CoreNetwork
//
//  Created by 정현우 on 11/1/24.
//

import Alamofire
import SwiftUICalendar

import SharedUtil

public enum DiaryEndPoint {
	case getCalendarByMonth(ym: YearMonth)
	case getDiaryByDate(ymd: YearMonthDay)
}

extension DiaryEndPoint: EndPoint {
	public var baseURL: String {
		return  "\(SecretConstants.baseURL)/diaries"
	}
	
	public var path: String {
		switch self {
		case .getCalendarByMonth(let ym):
			return "/calendar/\(ym.year)-\(String(format: "%02d", ym.month))"
		case .getDiaryByDate(let ymd):
			return "/date/\(ymd.year)-\(String(format: "%02d", ymd.month))-\(String(format: "%02d", ymd.day))"
		}
	}
	
	public var method: Alamofire.HTTPMethod {
		switch self {
		case .getCalendarByMonth:
			return .get
		case .getDiaryByDate:
			return .get
		}
	}
	
	public var task: APITask {
		switch self {
		case .getCalendarByMonth:
			return .requestPlain
		case .getDiaryByDate:
			return .requestPlain
		}
	}
	
	
}
