//
//  CategoryEndPoint.swift
//  Namo_SwiftUI
//
//  Created by 정현우 on 2/11/24.
//

import Alamofire

import SharedUtil

public enum CategoryEndPoint {
	case postCategory(data: CategoryEditRequestDTO)
	case patchCategory(id: Int, data: CategoryEditRequestDTO)
	case getAllCategory
	case deleteCategory(id: Int)
}

extension CategoryEndPoint: EndPoint {
	
	public var baseURL: String {
		return "\(SecretConstants.baseURL)/categories"
	}
	
	public var path: String {
		switch self {
		case .postCategory:
			return ""
		case .patchCategory(let id, _):
			return "/\(id)"
		case .getAllCategory:
			return ""
		case .deleteCategory(let id):
			return "/\(id)"
		}
	}
	
	public var method: Alamofire.HTTPMethod {
		switch self {
		case .postCategory:
			return .post
		case .patchCategory:
			return .patch
		case .getAllCategory:
			return .get
		case .deleteCategory:
			return .delete
		}
	}
	
	public var task: APITask {
		switch self {
		case .postCategory(let data):
			return .requestJSONEncodable(parameters: data)
		case .patchCategory(_, let data):
			return .requestJSONEncodable(parameters: data)
		case .getAllCategory:
			return .requestPlain
		case .deleteCategory:
			return .requestPlain
		}
	}
	
	
}
