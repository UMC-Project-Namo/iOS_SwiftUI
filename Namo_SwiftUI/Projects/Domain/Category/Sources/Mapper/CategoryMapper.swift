//
//  CategoryMapper.swift
//  DomainCategory
//
//  Created by 정현우 on 10/5/24.
//

import Foundation

import CoreNetwork

// MARK: - toEntity()
extension CategoryDTO {
	func toEntity() -> NamoCategory {
		return NamoCategory(
			categoryId: categoryId,
			categoryName: categoryName,
			colorId: colorId,
			baseCategory: baseCategory,
			shared: shared
		)
	}
}

extension CategoryEditRequestDTO {
	func toEntity() -> CategoryEdit {
		return CategoryEdit(
			categoryName: categoryName,
			colorId: colorId,
			isShared: isShared
		)
	}
}

// MARK: - toData()
extension NamoCategory {
	func toData() -> CategoryDTO {
		return  CategoryDTO(
			categoryId: categoryId,
			categoryName: categoryName,
			colorId: colorId,
			baseCategory: baseCategory,
			shared: shared
		)
	}
}

extension CategoryEdit {
	func toData() -> CategoryEditRequestDTO {
		return CategoryEditRequestDTO(
			categoryName: categoryName,
			colorId: colorId,
			isShared: isShared
		)
	}
}
