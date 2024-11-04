//
//  MoimScheduleMapper.swift
//  DomainMoimInterface
//
//  Created by 권석기 on 10/3/24.
//

import Foundation

import CoreNetwork
import DomainFriend
import SharedUtil

public extension MoimScheduleListResponseDTO {
    func toEntity() -> MoimScheduleItem {
        return .init(meetingScheduleId: meetingScheduleId,
                     title: title,
                     startDate: Date.ISO8601toDate(startDate).toYMDEHM(),
                     imageUrl: imageUrl,
                     participantCount: participantCount,
                     participantNicknames: participantNicknames)
    }
}

public extension MoimSchedule {
    func toDto() -> MoimScheduleRequestDTO {
        return .init(title: title,
                     imageUrl: nil,
                     period: PeriodDto(startDate: startDate.dateToISO8601(),
                                       endDate: endDate.dateToISO8601()),
                     location: LocationDto(longitude: longitude,
                                           latitude: latitude,
                                           locationName: locationName,
                                           kakaoLocationId: kakaoLocationId),
                     participants: participants.map { $0.userId })
    }
}

public extension MoimSchedule {
    func toEditDto() -> MoimScheduleEditRequestDTO {
        .init(title: title,
              imageUrl: imageUrl,
              period: PeriodDto(startDate: startDate.dateToISO8601(),
                                endDate: startDate.dateToISO8601()),
              location: LocationDto(longitude: longitude,
                                    latitude: latitude,
                                    locationName: locationName,
                                    kakaoLocationId: kakaoLocationId),
              participantsToAdd: [],
              participantsToRemove: [])
    }
}

public extension MoimScheduleResonseDTO {
    func toEntity() -> MoimSchedule {
        .init(scheduleId: scheduleId,
              title: title,
              imageUrl: imageUrl,
              startDate: Date.ISO8601toDate(startDate),
              endDate: Date.ISO8601toDate(endDate),
              longitude: locationInfo.longitude,
              latitude: locationInfo.latitude,
              locationName: locationInfo.locationName,
              kakaoLocationId: locationInfo.kakaoLocationId,
              participants: participants.map { $0.toEntity() })
    }
}

public extension ParticipantsDto {
    func toEntity() -> Participant {
        .init(participantId: participantId,
              userId: userId,
              isGuest: isGuest,
              nickname: nickname,
              colorId: colorId,
              isOwner: isOwner)
    }
}

public extension Friend {
    func toParticipant() -> Participant {
        .init(participantId: 0,
              userId: memberId,
              isGuest: false,
              nickname: nickname,
              colorId: favoriteColorId,
              isOwner: false)
    }
}
