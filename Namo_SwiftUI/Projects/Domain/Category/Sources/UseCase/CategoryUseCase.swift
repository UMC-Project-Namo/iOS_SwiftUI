//
//  CategoryUseCase.swift
//  DomainCategory
//
//  Created by 정현우 on 9/19/24.
//

import SwiftUI

import ComposableArchitecture

import SharedUtil
import CoreNetwork

@DependencyClient
public struct CategoryUseCase {
	// 카테고리 가져오기
	public func getAllCategory() async throws -> [NamoCategory] {
		do {
			let response: BaseResponse<[CategoryDTO]> = try await APIManager.shared.performRequest(endPoint: CategoryEndPoint.getAllCategory)
			
			return response.result?.map({$0.toEntity()}) ?? []
		} catch (let error) {
			print(error.localizedDescription)
			// TODO: error mapping
			throw error
		}
	}
	
	// 카테고리 수정하기
	public func patchCategory(categoryId: Int, data: CategoryEdit) async throws -> Void {
		do {
			let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: CategoryEndPoint.patchCategory(id: categoryId, data: data.toData()))
			
			return
		} catch (let error) {
			print(error.localizedDescription)
			// TODO: error mapping
			throw error
		}
	}
	
	// 카테고리 생성
	public func postCategory(data: CategoryEdit) async throws -> Void {
		do {
			let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: CategoryEndPoint.postCategory(data: data.toData()))
			
			return
		} catch (let error) {
			print(error.localizedDescription)
			// TODO: error mapping
			throw error
		}
	}
	
	// 카테고리 제거
	public func deleteCategory(categoryId: Int) async throws -> Void {
		do {
			let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: CategoryEndPoint.deleteCategory(id: categoryId))
			
			return
		} catch (let error) {
			print(error.localizedDescription)
			// TODO: error mapping
			throw error
		}
	}
}

extension CategoryUseCase: DependencyKey {
	public static var liveValue: CategoryUseCase {
		return CategoryUseCase()
	}
}

extension DependencyValues {
	public var categoryUseCase: CategoryUseCase {
		get { self[CategoryUseCase.self] }
		set { self[CategoryUseCase.self] = newValue }
	}
}
