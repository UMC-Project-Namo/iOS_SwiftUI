//
//  MoimDiaryRepository.swift
//  Namo_SwiftUI
//
//  Created by 서은수 on 4/6/24.
//

import Foundation

import CoreNetwork

/// 모임 기록 API
protocol MoimDiaryRepository {
    func createMoimDiaryPlace(moimScheduleId: Int, req: EditMoimDiaryPlaceReqDTO) async -> Bool
	func changeMoimDiaryPlace(activityId: Int, req: EditMoimDiaryPlaceReqDTO, deleteImageIds: [Int]) async -> Bool
    func deleteMoimDiaryPlace(activityId: Int) async -> Bool
    func editMoimDiary(scheduleId: Int, req: ChangeMoimDiaryRequestDTO) async -> Bool
    func deleteMoimDiary(moimScheduleId: Int) async -> Bool
    func getMonthMoimDiary(req: GetMonthMoimDiaryReqDTO) async -> GetMonthMoimDiaryResDTO?
    func getOneMoimDiary(moimScheduleId: Int) async -> GetOneMoimDiaryResDTO?
    func getOneMoimDiaryDetail(moimScheduleId: Int) async -> Diary_Old?
    func deleteMoimDiaryOnPersonal(scheduleId: Int) async -> Bool
}
