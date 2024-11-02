//
//  DiaryCalendar.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

public struct DiaryCalendar: Decodable {
	public let year: Int
	public let month: Int
	public let diaryDateForPersonal: [Int]
	public let diaryDateForMeeting: [Int]
	public let diaryDateForBirthday: [Int]
	
	public init(year: Int, month: Int, diaryDateForPersonal: [Int], diaryDateForMeeting: [Int], diaryDateForBirthday: [Int]) {
		self.year = year
		self.month = month
		self.diaryDateForPersonal = diaryDateForPersonal
		self.diaryDateForMeeting = diaryDateForMeeting
		self.diaryDateForBirthday = diaryDateForBirthday
	}
}
