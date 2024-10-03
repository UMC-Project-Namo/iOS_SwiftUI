//
//  MoimEndPoint.swift
//  Namo_SwiftUI
//
//  Created by 정현우 on 2/17/24.
//

import Alamofire
import Foundation
import SharedUtil

public enum MoimEndPoint {
    case getMoimList
    case createMoim(MoimScheduleRequestDTO)
}

extension MoimEndPoint: EndPoint {
    public var baseURL: String {
        return "\(SecretConstants.baseURL)/schedules"
    }
    
    public var path: String {
        switch self {
        case .getMoimList, .createMoim:
            return "/meeting"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getMoimList:
            return .get
        case .createMoim:
            return .post
        }
    }
    
    public var task: APITask {
        switch self {
        case .getMoimList:
               return .requestPlain
        case let .createMoim(moimDto):            
            return .requestParameters(parameters: moimDto.toDictionary ?? [:], encoding: URLEncoding.default)
        }
    }
    
    public var headers: HTTPHeaders? {
        switch self {
//        case .createMoim:
//            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

extension Encodable {
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
