//
//  APIManager.swift
//  Namo_SwiftUI
//
//  Created by 박민서 on 1/29/24.
//

import Foundation
import Alamofire

import SharedUtil

/// 네트워크 요청을 관리하는 싱글톤 클래스인 APIManager입니다.
public final class APIManager {
    
    public static let shared = APIManager()
    
    private init () { }
    
    /// Endpoint에 따라 네트워크 요청을 수행하고, 결과를 `DataResponse`로 반환합니다.
    ///
    /// - Parameters:
    ///     - `endPoint`: 네트워크 요청을 정의하는 `Endpoint`
    /// - Returns: Alamofire Request 응답 결과인 `DataResponse<Data, AFError>`
	public func requestData(endPoint: EndPoint) async -> DataResponse<Data, AFError> {
                 
        var response = await makeDataRequest(endPoint: endPoint).serializingData().response
    
        // 403 에러 발생 시 토큰 재발급 시도
        if let statusCode = response.response?.statusCode, statusCode == 403 {
            response = await handleTokenReissuanceAndRetry(endPoint: endPoint, originalResponse: response)
        }
        
        return response
    }
    
    /// 403 응답 코드 처리 및 토큰 재발급 후 원래 요청을 재시도하는 함수
    ///
    /// - Parameters:
    ///   - endPoint: 원래 요청의 Endpoint 정보
    ///   - originalResponse: 최초 요청에서 반환된 DataResponse
    /// - Returns: 토큰 재발급 실패 시 기존 응답을 반환하고, 성공 시 원래 요청을 재시도하여 그 결과를 반환
    /// - Note: 이 함수는 403 Forbidden 응답이 발생했을 때 호출됩니다. 토큰 재발급을 시도하고,
    ///         재발급이 성공하면 해당 요청을 다시 시도하여 최종 응답을 반환합니다.
    private func handleTokenReissuanceAndRetry(endPoint: EndPoint, originalResponse: DataResponse<Data, AFError>) async -> DataResponse<Data, AFError> {
        // 토큰 재발급 처리 시도
        guard await handleTokenReissuance() else {
            print("==== 토큰 갱신 실패로 로그아웃 처리됨 ====")
            // 로그아웃 처리
            DispatchQueue.main.async {
                UserDefaults.standard.set(false, forKey: "isLogin")
            }
            return originalResponse
        }

        // 재발급 성공 후 원래 요청 재시도
        return await makeDataRequest(endPoint: endPoint).serializingData().response
    }
    
    /// 토큰 재발급을 처리하는 함수입니다.
    /// 토큰 재발급, 저장 성공 시 true, 실패 시 false를 반환합니다.
    private func handleTokenReissuance() async -> Bool {
        do {
            // 토큰 재발급을 시도합니다
            let tokens = try await reissueTokens()
            // 토큰 저장을 시도합니다
            try storeTokens(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
            return true
        } catch {
            print("토큰 갱신 실패: \(error)")
            return false
        }
    }
    
    /// 새로운 토큰을 키체인에 저장하는 함수입니다.
    private func storeTokens(accessToken: String, refreshToken: String) throws {
        do {
            // 새로운 토큰 키체인 저장을 시도합니다
            try KeyChainManager.addItem(key: "accessToken", value: accessToken)
            try KeyChainManager.addItem(key: "refreshToken", value: refreshToken)
            print("새 토큰 저장 완료")
        } catch {
            print("토큰 저장 실패: \(error)")
            throw error
        }
    }
    
    /// 토큰 재발급 요청, 응답을 처리하는 함수입니다
    private func reissueTokens() async throws -> TokenReissuanceResponseDTO {
        do {
            // 기존 토큰 가져오기를 시도합니다
            let accessToken = try KeyChainManager.readItem(key: "accessToken")
            let refreshToken = try KeyChainManager.readItem(key: "refreshToken")
            
            // 새로운 토큰 재발급을 시도합니다
            let response = await makeDataRequest(endPoint: AuthEndPoint.reissuanceToken(token: TokenReissuanceRequestDTO(accessToken: accessToken, refreshToken: refreshToken))).serializingData().response
            
            // 403의 경우 throw 처리
            if response.response?.statusCode == 403 {
                throw APIError.customError("Refresh token expired")
            }
            
            // 결과 디코드
            let result = try response.result.get()
            let decodedData = try result.decode(type: BaseResponse<TokenReissuanceResponseDTO>.self, decoder: JSONDecoder())
            guard let tokens = decodedData.result else {
                throw APIError.customError("Invalid token reissuance response")
            }
            
            return tokens
        } catch {
            throw APIError.customError("Failed to reissue tokens: \(error)")
        }
    }
    
	/// 네트워크 요청을 수행하고 결과를 디코딩하여 반환합니다.
	///
	/// - Parameters:
	///   - endPoint: 네트워크 요청을 정의하는 Endpoint
	///   - decoder: 사용할 디코더. 기본값은 `JSONDecoder()`입니다.
	/// - Returns: 디코딩된 Response
	public func performRequest<T: Decodable>(endPoint: EndPoint, decoder: DataDecoder = JSONDecoder()) async -> BaseResponse<T>? {
		var result: Data = .init()
		do {
			let request = await self.requestData(endPoint: endPoint)
			
			result = try request.result.get()
		} catch {
			print("네트워크 에러" + (String(data: result, encoding: .utf8) ?? ""))
			ErrorHandler.shared.handleAPIError(.networkError)
			return nil
		}

		do {

			let decodedData = try result.decode(type: BaseResponse<T>.self, decoder: decoder)
			return decodedData
		} catch {
			print("디코딩 에러" + (String(data: result, encoding: .utf8) ?? ""))
			ErrorHandler.shared.handleAPIError(.parseError(error.localizedDescription))
			return nil
		}
		

    }
    
    // BaseResponse 없는 메소드
	public func performRequestWithoutBaseResponse<T: Decodable>(endPoint: EndPoint, decoder: DataDecoder = JSONDecoder()) async -> T? {
        do {
            let request = await self.requestData(endPoint: endPoint)
            let result = try request.result.get()
            print("inferred DataType to be decoded : \(T.self)")
            let decodedData = try result.decode(type: T.self, decoder: decoder)
            return decodedData
        } catch {
            print("에러 발생: \(error)")
            return nil
        }
    }
}

public extension APIManager {
    // endpoint의 task에 따라 request 데이터 생성 메서드
    
    /// Endpoint의 task에 따라 request 데이터를 생성하는 메서드입니다.
    ///
    /// - Parameters:
    ///     - `endPoint`: 네트워크 요청을 정의하는 `Endpoint`
    /// - Returns: Alamofire에서 생성한 `DataRequest`
    private func makeDataRequest(endPoint: EndPoint) -> DataRequest {
        
      switch endPoint.task {
          
      case .requestPlain:
        return AF.request(
          "\(endPoint.baseURL)\(endPoint.path)",
          method: endPoint.method,
          headers: endPoint.headers,
          interceptor: AuthManager()
		)
        
      case let .requestJSONEncodable(parameters):
          return AF.request(
            "\(endPoint.baseURL)\(endPoint.path)",
            method: endPoint.method,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: endPoint.headers,
            interceptor: AuthManager()
          )
        
      case let .requestCustomJSONEncodable(parameters, encoder):
          return AF.request(
            "\(endPoint.baseURL)\(endPoint.path)",
            method: endPoint.method,
            parameters: parameters,
            encoder: .json(encoder: encoder),
            headers: endPoint.headers,
            interceptor: AuthManager()
          )
        
      case let .requestParameters(parameters, encoding):
          return AF.request(
            "\(endPoint.baseURL)\(endPoint.path)",
            method: endPoint.method,
            parameters: parameters,
            encoding: encoding,
            headers: endPoint.headers,
            interceptor: AuthManager()
          )
          
      case let .uploadImages(images, imageKeyName):
          return AF.upload(multipartFormData: { multipartFormData in
              for image in images {
				  if let image = image {
					  multipartFormData.append(image, withName: imageKeyName, fileName: "\(image).png", mimeType: "image/png")
				  }
              }
		  }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)")!, method: endPoint.method, headers: endPoint.headers, interceptor: AuthManager())
		  
	  case let .uploadImagesWithBody(images, body, imageKeyName):
		  return AF.upload(multipartFormData: { multipartFormData in
			  for image in images {
				  if let image = image {
					  multipartFormData.append(image, withName: imageKeyName, fileName: "\(image).jpeg", mimeType: "image/jpeg")
				  }
			  }
			  
			  for (key, value) in body {
				  if let data = String(describing: value).data(using: .utf8) {
					  multipartFormData.append(data, withName: key)
				  }
			  }
		  }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)")!, method: endPoint.method, headers: endPoint.headers, interceptor: AuthManager())
		  
	  case let .uploadImagesWithParameter(images, params, imageKeyName):
		  return AF.upload(multipartFormData: { multipartFormData in
			  for image in images {
				  if let image = image {
					  multipartFormData.append(image, withName: imageKeyName, fileName: "\(image).jpeg", mimeType: "image/jpeg")
				  }
			  }
		  }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)\(queryString(from: params))")!, method: endPoint.method, headers: endPoint.headers, interceptor: AuthManager())
          
      case let .authRequestJSONEncodable(parameters):
          return AF.request(
            "\(endPoint.baseURL)\(endPoint.path)",
            method: endPoint.method,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: endPoint.headers
          )
		  
	  case .authRequestPlain:
		  return AF.request(
			"\(endPoint.baseURL)\(endPoint.path)",
			method: endPoint.method,
			headers: endPoint.headers
		  )
          
      case let .requestParametersExAPI(parameters, encoding):
          return AF.request(
            "\(endPoint.baseURL)\(endPoint.path)",
            method: endPoint.method,
            parameters: parameters,
            encoding: encoding,
            headers: endPoint.headers
          )
      }
    }
	
	func queryString(from parameters: [String: Any]) -> String {
		var components: [String] = []
		
		for (key, value) in parameters {
			if let arrayValue = value as? [Any] {
				for element in arrayValue {
					components.append("\(key)=\(element)")
				}
			} else {
				components.append("\(key)=\(value)")
			}
		}
		print(components.isEmpty ? "" : "?" + components.joined(separator: "&"))
		return components.isEmpty ? "" : "?" + components.joined(separator: "&")
	}
}

public extension APIManager {
    func KakaoMapAPIRequest(query: String, x: Double?=nil, y: Double?=nil, radius: Int?=nil, page: Int?=nil, size: Int?=nil, completion: @escaping (KakaoMapResponseDTO?, Error?) -> Void) {
        
        var params: Parameters = [ "query" : query ]
        
        if let x = x { params["x"] = String(x) }
        if let y = y { params["y"] = String(y) }
        if let radius = radius { params["radius"] = radius }
        if let page = page { params["page"] = page }
        if let size = size { params["size"] = size }
        
        let headers: HTTPHeaders = [ "Authorization" : "KakaoAK \(SecretConstants.kakaoMapRESTAPIKey)"]
        
        AF.request(
            "https://dapi.kakao.com/v2/local/search/keyword.json",
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: KakaoMapResponseDTO.self) { dataResponse in
            switch dataResponse.result {
            case .success(let success):
                completion(success, nil)
                print(success)
            case .failure(let error):
                print("에러난다:\(error)")
                completion(nil, error)
            }
        }
    }
}
