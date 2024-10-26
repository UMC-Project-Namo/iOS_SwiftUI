//
//  ScheduleUseCase.swift
//  DomainSchedule
//
//  Created by 정현우 on 9/19/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import CoreNetwork
import SharedUtil

@DependencyClient
public struct ScheduleUseCase {
    let MAX_SCHEDULE = screenHeight < 800 ? 3 : 4
    // 월별 스케쥴 받아오기
    public func getSchedule(startDate: YearMonthDay, endDate: YearMonthDay) async -> [Schedule] {
        let startDateString = String(format: "%04d-%02d-%02d", startDate.year, startDate.month, startDate.day)
        let endDateString = String(format: "%04d-%02d-%02d", endDate.year, endDate.month, endDate.day)
        
        do {
            let response: BaseResponse<GetMonthlyScheduleResponseDTO> = try await APIManager.shared.performRequest(
                endPoint: ScheduleEndPoint.getSchedule(
                    startDate: startDateString, endDate: endDateString
                )
            )
            
            return response.result?.map({$0.toEntity()}) ?? []
        } catch(let e) {
            // TODO: error handling
            print(e.localizedDescription)
            return []
        }
    }
    
    // 스케쥴을 캘린더에 뿌리기 위한 스케쥴로 변경
    public func mapScheduleToCalendar(_ schedules: [Schedule]) -> [YearMonthDay: [CalendarSchedule]] {
        var schedulesDict: [YearMonthDay: [CalendarSchedule]] = [:]
        
        // 서버에서 받아온 스케쥴을 돌면서
        schedules.forEach { schedule in
            let startDate = schedule.startDate
            let endDate = schedule.endDate.adjustDateIfMidNight()  // 종료일이 만약 자정이라면 -1초

            let startYMD = startDate.toYMD()
            
            // 일정 지속기간 중 모든 day를 구함
            let days = datesBetween(startDate: startDate, endDate: endDate)
            
            // 우선 시작날 캘린더에 표시될 postion을 구함
            // 그 뒤 day들은 이 postion을 쭉 이어감. 단 주가 바뀌고 해당 postion의 위쪽이 비어있다면 올라감
            var currentPosition = findPostion(schedulesDict[startYMD] ?? [])
            
            // 일정 지속기간동안 매일
            days.forEach { day in
                // 만약 주가 바뀌면(일요일) position 다시 계산
                if day.isSunday() {
                    currentPosition = findPostion(schedulesDict[day.toYMD()] ?? [])
                }
                
                let currentYMD = day.toYMD()
                
                // schedulesDict에 해당 날짜에 data가 nil이 아니라면 = 해당 날짜에 이미 스케쥴이 있다면
                if schedulesDict[currentYMD] != nil {
                    // 만약 현재 인덱스에 스케쥴이 nil인채로 있을 수 있음
                    // 그 nil인 스케쥴을 지우고
                    if let index = schedulesDict[currentYMD]!.firstIndex(where: {$0.position == currentPosition && $0.schedule == nil}) {
                        schedulesDict[currentYMD]?.remove(at: index)
                    }
                    // 그 자리에 스케쥴 추가
                    schedulesDict[currentYMD]?.append(CalendarSchedule(position: currentPosition, schedule: schedule))
                } else {
                    // schedulesDict에 해당 날짜에 data가 nil이라면 = 해당 날짜에 스케쥴이 없다면
                    // 그냥 현재 스케쥴을 추가함
                    schedulesDict[currentYMD] = [CalendarSchedule(position: currentPosition, schedule: schedule)]
                }
                
                // 아래는 캘린더 표시되기 위한 작업이므로
                // max이상이거나 currentPostion이 0미만이라면 다음 날로
                if currentPosition >= MAX_SCHEDULE || currentPosition < 0 { return }
                
                if let positions = schedulesDict[currentYMD]?.map({$0.position}) {
                    
                    var tempPostion = currentPosition
                    
                    while tempPostion >= 0 {
                        if !positions.contains(tempPostion) {
                            // 최고 포지션 밑에서 만약 스케쥴이 없다면 nil로 추가(캘린더에서 줄 맞춤을 위함)
                            schedulesDict[currentYMD]?.append(CalendarSchedule(position: tempPostion, schedule: nil))
                        }
                        
                        tempPostion -= 1
                    }
                    
                    schedulesDict[currentYMD]?.sort(by: {$0.position < $1.position})
                }
                
            }  //: days forEach
        } //: schedules forEach
        return schedulesDict
    }
    
    // 현재 날짜의 스케쥴들을 확인하고, 추가될 스케쥴의 포지션을 구함
    func findPostion(_ schedules: [CalendarSchedule]) -> Int {
        
        if schedules.isEmpty {
            return 0
        }
        
        // 스케쥴인 nil인 postion
        let nilSchedulePositions = schedules.compactMap { $0.schedule == nil ? $0.position : nil }
         
        if !nilSchedulePositions.isEmpty {
            // nil인 포지션이 있다면 그 중 최소값을 찾음
            return nilSchedulePositions.min()!
        } else {
            // nil인 포지션이 없다면, 마지막 postion의 다음 postion으로 지정
            return schedules.last!.position + 1
        }
    }
    
    // 시작일과 종료일 사이 Date 리턴
    func datesBetween(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentYMD = startDate.toYMD()
        let endYMD = endDate.toYMD()
        
        while currentYMD <= endYMD {
            dates.append(currentYMD.toDate())
            currentYMD = currentYMD.addDay(value: 1)
        }
        
        return dates
    }
    
    // detailView의 Schedule에 표시할 시간을 리턴하는 함수
    // 하루 일정인지 여러 일 지속 일정인지에 따라 리턴 다르게
    public func getScheduleTimeWithBaseYMD(
        schedule: Schedule,
        baseYMD: YearMonthDay
    ) -> String {
        if schedule.startDate.toYMD() == schedule.endDate.adjustDateIfMidNight().toYMD() {
            // 같은 날이라면 그냥 시작시간-종료시간 표시
            return "\(schedule.startDate.toHHmm()) - \(schedule.endDate.adjustDateIfMidNight().toHHmm())"
        } else if baseYMD == schedule.startDate.toYMD() {
            // 여러 일 지속 스케쥴의 시작일이라면
            return "\(schedule.startDate.toHHmm()) - 23:59"
        } else if baseYMD == schedule.endDate.toYMD() {
            // 여러 일 지속 스케쥴의 종료일이라면
            return "00:00 - \(schedule.endDate.adjustDateIfMidNight().toHHmm())"
        } else {
            // 여러 일 지속 스케쥴의 중간이라면
            return "00:00 - 23:59"
        }
    }
    
    // Schedule 객체에서 일정 생성/편집에서 사용하는 ScheduleEdit 객체로 변환
    public func scheduleToScheduleEdit(
        schedule: Schedule? = nil,
        selectDate: YearMonthDay
    ) -> ScheduleEdit {
        if let schedule = schedule {
            return ScheduleEdit(
                title: schedule.title,
                category: schedule.categoryInfo,
                period: SchedulePeriod(
                    startDate: schedule.startDate,
                    endDate: schedule.endDate
                ),
                location: schedule.locationInfo,
                reminderTrigger: schedule.notificationInfo.map {$0.trigger}
            )
        } else {
            return ScheduleEdit(
                period: SchedulePeriod(
                    startDate: selectDate.toDateWithTime(hour: 8),
                    endDate: selectDate.toDateWithTime(hour: 9)
                )
            )
        }
    }
	
	// 일정 생성 요청
	public func createSchedule(_ schedule: ScheduleEdit) async throws {
		var schedule = schedule
		schedule.reminderTrigger = formatReminderTrigger(reminderTriggers: schedule.reminderTrigger ?? [])
		
		let _: BaseResponse<Int> = try await APIManager.shared.performRequest(endPoint: ScheduleEndPoint.createSchedule(schedule: schedule.toData()))
	}
	
	// 일정 삭제 요청
	public func deleteSchedule(_ scheduleId: Int) async throws {
		let _: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: ScheduleEndPoint.deleteSchedule(scheduleId: scheduleId))
	}
	
	// 일정 업데이트 요청
	public func updateSchedule(scheduleId: Int, schedule: ScheduleEdit) async throws {
		var schedule = schedule
		schedule.reminderTrigger = formatReminderTrigger(reminderTriggers: schedule.reminderTrigger ?? [])
		
		let _: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: ScheduleEndPoint.updateSchedule(scheduleId: scheduleId, schedule: schedule.toData()))
	}
	
	// 보여지는 알림(ex 정시, 5분 전 등)을 서버에서 요구하는 포맷으로 변경합니다.
	func formatReminderTrigger(reminderTriggers: [String]) -> [String] {
		return reminderTriggers.map { trigger in
			if trigger.contains("정시") {
				return "ST"
			} else if trigger.contains("일 전") {
				let number = Int(trigger.replacingOccurrences(of: "일 전", with: ""))!
				return "D\(number)"
			} else if trigger.contains("시간 전") {
				let number = Int(trigger.replacingOccurrences(of: "시간 전", with: ""))!
				return "H\(number)"
			} else if trigger.contains("분 전") {
				let number = Int(trigger.replacingOccurrences(of: "분 전", with: ""))!
				return "M\(number)"
			} else {
				return ""
			}
			
 
		}
	}
    
    
    
    
}

extension ScheduleUseCase: DependencyKey {
    public static var liveValue: ScheduleUseCase {
        return ScheduleUseCase()
    }
}

extension DependencyValues {
    public var scheduleUseCase: ScheduleUseCase {
        get { self[ScheduleUseCase.self] }
        set { self[ScheduleUseCase.self] = newValue }
    }
}
