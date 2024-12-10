//
//  DiaryUseCase.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import CoreNetwork
import SharedUtil

@DependencyClient
public struct DiaryUseCase {
	// 캘린더 일정 +-1 달씩 월별로 가져오기
	public func getCalendarByMonth(ym: YearMonth) async throws -> [YearMonthDay: DiaryScheduleType] {
		var result: [YearMonthDay: DiaryScheduleType] = [:]
		
		for i in -1...1 {
			let currentYM = ym.addMonth(i)
			let response: BaseResponse<DiaryCalendar> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.getCalendarByMonth(ym: currentYM))
			
			response.result?.diaryDateForPersonal.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .personalOrBirthdaySchedule
			}
			
			response.result?.diaryDateForBirthday.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .personalOrBirthdaySchedule
			}
			
			response.result?.diaryDateForMeeting.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .meetingSchedule
			}
			
		}
		
		return result
	}
	
	// 특정 일 스케쥴 가져오기
	public func getDiaryByDate(ymd: YearMonthDay) async throws -> [DiarySchedule] {
		let response: BaseResponse<[DiarySchedule]> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.getDiaryByDate(ymd: ymd))
		
		return response.result ?? []
	}
	
	// detailView의 Schedule에 표시할 시간을 리턴하는 함수
	// 하루 일정인지 여러 일 지속 일정인지에 따라 리턴 다르게
	public func getScheduleTimeWithBaseYMD(
		schedule: DiarySchedule,
		baseYMD: YearMonthDay
	) -> String {
		if schedule.scheduleStartDate.toYMD() == schedule.scheduleEndDate.adjustDateIfMidNight().toYMD() {
			// 같은 날이라면 그냥 시작시간-종료시간 표시
			return "\(schedule.scheduleStartDate.toHHmm()) - \(schedule.scheduleEndDate.adjustDateIfMidNight().toHHmm())"
		} else if baseYMD == schedule.scheduleStartDate.toYMD() {
			// 여러 일 지속 스케쥴의 시작일이라면
			return "\(schedule.scheduleStartDate.toHHmm()) - 23:59"
		} else if baseYMD == schedule.scheduleEndDate.toYMD() {
			// 여러 일 지속 스케쥴의 종료일이라면
			return "00:00 - \(schedule.scheduleEndDate.adjustDateIfMidNight().toHHmm())"
		} else {
			// 여러 일 지속 스케쥴의 중간이라면
			return "00:00 - 23:59"
		}
	}
    
    /// SchduleId를 통해 해당 일정의 기록을 가져옵니다
    public func getDiaryBySchedule(id: Int) async throws -> Diary {
        let response: BaseResponse<DiaryResponseDTO> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.getDiaryBySchedule(id: id))
        
        if response.code != 200 {
            throw APIError.customError("기록 로드 실패: 응답 코드 \(response.code)")
        }
        
        guard let diary = response.result?.toEntity() else {
            throw APIError.parseError("result.result is nil")
        }
        
        return diary
    }
    
    /// 해당 일정의 기록을 수정합니다
    public func patchDiary(id: Int, reqDiary: Diary, deleteImages: [Int]) async throws -> Void {
        let response: BaseResponse<String > = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.patchDiary(id: id, reqDto: reqDiary.toPatchDTO(deleteImages: deleteImages)))
        
        if response.code != 200 {
            throw APIError.customError("기록 수정 실패: 응답 코드 \(response.code)")
        }
    }
    
    /// 해당 ScheduleId의 일정의 기록을 추가합니다
    public func postDiary(scheduleId: Int, reqDiary: Diary) async throws -> Void {
        let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.postDiary(reqDto: reqDiary.toPostDTO(scheduleId: scheduleId)))
        
        if response.code != 200 {
            throw APIError.customError("기록 작성 실패: 응답 코드 \(response.code)")
        }
    }
    
    /// 이미지 파일들을 S3에 업로드 후, 순서를 맞춰 DiaryImage 배열로 반환합니다.
    public func postDiaryImages(scheduleId: Int, images: [UIImage]) async throws -> [DiaryImage] {
        let compImgs = try images.map { image in
            guard let compressedData = image.jpegData(compressionQuality: 0.6) else {
                throw NSError(domain: "이미지 압축 에러", code: 1001)
            }
            return compressedData
        }
        
        // 이미지 병렬 업로드 처리
        return try await withThrowingTaskGroup(of: (Int, String).self) { group in
            for (index, img) in compImgs.enumerated() {
                group.addTask {
                    let fileName = "diary_image_schedule_\(scheduleId)_index_\(index)_\(Int(Date().timeIntervalSince1970))_\(UUID().uuidString)"
                    
                    guard let url = try await APIManager.shared.getPresignedUrl(prefix: "diary", filename: fileName).result else {
                        throw APIError.customError("S3 getPresignedUrl 에러")
                    }
                    
                    guard let uploadedUrl = try await APIManager.shared.uploadImageToS3(presignedUrl: url, imageFile: img) else {
                        throw APIError.customError("S3 uploadImageToS3 에러")
                    }
                    
                    return (index, uploadedUrl)
                }
            }
            
            var uploadedImages: [DiaryImage] = []
            for try await (index, uploadedUrl) in group {
                // TODO: index 0부터인지 1부터인지 확인
                uploadedImages.append(DiaryImage(orderNumber: index, imageUrl: uploadedUrl))
            }
            
            return uploadedImages
        }
    }
    
    /// 해당 일정 기록을 삭제합니다.
    public func deleteDiary(id: Int) async throws -> Void {
        let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.deleteDiary(id: id))
        
        if response.code != 200 {
            throw APIError.customError("기록 삭제 실패: 응답 코드 \(response.code)")
        }
    }
}

extension DiaryUseCase: DependencyKey {
	public static var liveValue: DiaryUseCase {
		return DiaryUseCase()
	}
}

extension DependencyValues {
	public var diaryUseCase: DiaryUseCase {
		get { self[DiaryUseCase.self] }
		set { self[DiaryUseCase.self] = newValue }
	}
}
