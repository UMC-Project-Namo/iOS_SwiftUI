//
//  DiaryInteractor.swift
//  Namo_SwiftUI
//
//  Created by 서은수 on 3/16/24.
//

import Foundation

protocol DiaryInteractor {
    func createDiary(scheduleId: String, content: String, images: [Data?]) async
    func getMonthDiary(request: GetDiaryRequestDTO) async
    func changeDiary(scheduleId: String, content: String, images: [Data?]) async -> Bool
    func deleteDiary(diaryId: Int) async -> Bool
}
