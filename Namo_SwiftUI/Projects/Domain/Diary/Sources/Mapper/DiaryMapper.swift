//
//  DiaryMapper.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

import Foundation

import CoreNetwork
import SharedUtil

// MARK: - toEntity()
extension DiaryCalendarDTO {
	func toEntity() -> DiaryCalendar {
		return DiaryCalendar(
			year: year,
			month: month,
			diaryDateForPersonal: diaryDateForPersonal,
			diaryDateForMeeting: diaryDateForMeeting,
			diaryDateForBirthday: diaryDateForBirthday
		)
	}
}

extension DiaryScheduleDTO {
	func toEntity() -> DiarySchedule {
		return DiarySchedule(
			scheduleId: scheduleId,
			scheduleType: scheduleType,
			categoryInfo: categoryInfo.toEntity(),
			scheduleStartDate: Date.ISO8601toDate(scheduleStartDate),
			scheduleEndDate: Date.ISO8601toDate(scheduleEndDate),
			scheduleTitle: scheduleTitle,
			diaryId: diaryId,
			participantInfo: participantInfo.toEntity()
		)
	}
}

extension DiaryScheduleCategoryDTO {
	func toEntity() -> DiaryScheduleCategory {
		return DiaryScheduleCategory(
			name: name,
			colorId: colorId
		)
	}
}

extension DiaryScheduleParticipantDTO {
	func toEntity() -> DiaryScheduleParticipant {
		return DiaryScheduleParticipant(
			participantsCount: participantsCount,
			participantsNames: participantsNames
		)
	}
}

extension DiaryResponseDTO {
    func toEntity() -> Diary {
        return Diary(
            id: diaryId,
            content: content,
            enjoyRating: enjoyRating,
            images: mapAndSortDiaryImages(from: diaryImages)
        )
    }
    
    func mapAndSortDiaryImages(from responseDTOs: [DiaryImageResponseDTO]) -> [DiaryImage] {
        return responseDTOs
            .sorted(by: { $0.orderNumber < $1.orderNumber })
            .map { DiaryImage(id: $0.diaryImageId, orderNumber: $0.orderNumber, imageUrl: $0.imageUrl) }
    }
}

extension Diary {
    func toPostDTO(scheduleId: Int) -> DiaryPostRequestDTO {
        return DiaryPostRequestDTO(
            scheduleId: scheduleId,
            content: content,
            enjoyRating: enjoyRating,
            diaryImages: images.map { $0.toDTO() }
        )
    }
}

extension DiaryImageResponseDTO {
    func toEntity() -> DiaryImage {
        return DiaryImage(
            id: diaryImageId,
            orderNumber: orderNumber,
            imageUrl: imageUrl
        )
    }
}

extension DiaryImage {
    func toDTO() -> DiaryImageRequestDTO {
        return DiaryImageRequestDTO(
            orderNumber: orderNumber,
            imageUrl: imageUrl
        )
    }
}
