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
    case getDiaryBySchedule(id: Int)
    case patchDiary(id: Int, reqDto: DiaryPatchRequestDTO)
    case postDiary(reqDto: DiaryPostRequestDTO)
    case deleteDiary(id: Int)
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
        case .getDiaryBySchedule(let id):
            return "/\(id)"
        case .patchDiary(let id, _):
            return "/\(id)"
        case .postDiary:
            return ""
        case .deleteDiary(let id):
            return "/\(id)"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getCalendarByMonth:
            return .get
        case .getDiaryByDate:
            return .get
        case .getDiaryBySchedule:
            return .get
        case .patchDiary:
            return .patch
        case .postDiary:
            return .post
        case .deleteDiary:
            return .delete
        }
    }
    
    public var task: APITask {
        switch self {
        case .getCalendarByMonth:
            return .requestPlain
        case .getDiaryByDate:
            return .requestPlain
        case .getDiaryBySchedule:
            return .requestPlain
        case .patchDiary(_, let reqDto):
            return .requestJSONEncodable(parameters: reqDto)
        case .postDiary(let reqDto):
            return .requestJSONEncodable(parameters: reqDto)
        case .deleteDiary:
            return .requestPlain
        }
    }
    
}
