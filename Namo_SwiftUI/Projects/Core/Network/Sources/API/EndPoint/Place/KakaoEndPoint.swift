//
//  KakaoEndPoint.swift
//  Namo_SwiftUI
//
//  Created by 박민서 on 2/23/24.
//

import Alamofire

import SharedUtil

public enum KakaoEndPoint {
	case getKakaoMapAPIRequest(req: KakaoLocationSearchRequest)
}

extension KakaoEndPoint: EndPoint {
    
    public var baseURL: String {
        return "https://dapi.kakao.com/v2/local/search/keyword.json"
    }
    
    public var path: String {
        switch self {
        case .getKakaoMapAPIRequest:
            return ""
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getKakaoMapAPIRequest:
            return .get
        }
    }
    
    public var headers: HTTPHeaders? {
        switch self {
        case .getKakaoMapAPIRequest:
            return [ "Authorization" : "KakaoAK \(SecretConstants.kakaoMapRESTAPIKey)"]
        }
    }
    
    public var task: APITask {
        switch self {
        case let .getKakaoMapAPIRequest(req):
			var params: Parameters = [ "query" : req.query ]
            
			if let x = req.x { params["x"] = String(x) }
			if let y = req.y { params["y"] = String(y) }
			if let radius = req.radius { params["radius"] = radius }
			if let page = req.page { params["page"] = page }
			if let size = req.size { params["size"] = size }
            
            return .requestParametersExAPI(
                parameters: params,
                encoding: URLEncoding.default
            )
        }
    }
}
