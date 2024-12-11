//
//  MoimUseCase.swift
//  DomainMoim
//
//  Created by 권석기 on 10/2/24.
//

import Foundation

import CoreNetwork
import DomainMoimInterface
import SharedUtil

import ComposableArchitecture

// 모임 유즈케이스 구현체
extension MoimUseCase: DependencyKey {
    public static let liveValue = MoimUseCase(
        getMoimList: {
            do {
                let response: BaseResponse<[MoimScheduleListResponseDTO]>? = try await APIManager.shared.performRequest(endPoint: MoimEndPoint.getMoimList)
                guard let data = response?.result else { return [] }
                return data.map { $0.toEntity() }
            } catch {
                print(error.localizedDescription)
                throw error
            }
        },
        createMoim: { moim, uiImage in
            do {                
                var moimDto = moim.toDto()
                
                // 선택한 이미지 파일이 존재하는 경우에만 요청
                // 이미지 렌더시 메모리 사용량을 줄이기 위해서는 해상도를 조정해야함
                if let image = uiImage,
                   let imageFile = image.resize(newWidth: 55).jpegData(compressionQuality: 0.6)
                {
                    let filename = "schedule_cover_\(Int(Date().timeIntervalSince1970))_\(UUID().uuidString)"
                    let url = try await APIManager.shared.getPresignedUrl(prefix: "activity", filename: filename).result ?? ""
                    let uploadedUrl = try await APIManager.shared.uploadImageToS3(presignedUrl: url, imageFile: imageFile)
                    moimDto.imageUrl = uploadedUrl
                }
                
                let response: BaseResponse<Int>? = try await APIManager.shared.performRequest(endPoint: MoimEndPoint.createMoim(moimDto))
            } catch {
                print(error.localizedDescription)
            }
        },
        getMoimDetail: { meetingScheduleId in
            do {
                let response: BaseResponse<MoimScheduleResonseDTO> = try await APIManager.shared.performRequest(endPoint: MoimEndPoint.getMoimDetail(meetingScheduleId))
                guard let data = response.result else { fatalError() }
                
                return data.toEntity()
            } catch {
                print(error.localizedDescription)
                throw error
            }
        },
        withdrawMoim: { meetingScheduleId in
            do {
                let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: MoimEndPoint.withdrawMoim(meetingScheduleId))
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }, editMoim: { moim, uiImage in
            do {
                var moimReqDto = moim.toEditDto()
                
                if let image = uiImage,
                   let imageFile = image.resize(newWidth: 55).jpegData(compressionQuality: 0.6)
                {
                    
                    let filename = "schedule_cover_\(Int(Date().timeIntervalSince1970))_\(UUID().uuidString)"
                    let url = try await APIManager.shared.getPresignedUrl(prefix: "activity", filename: filename).result!
                    let uploadedUrl = try await APIManager.shared.uploadImageToS3(presignedUrl: url, imageFile: imageFile)
                    moimReqDto.imageUrl = uploadedUrl
                }
                
                let response: BaseResponse<String> = try await APIManager.shared.performRequest(endPoint: MoimEndPoint.editMoim(meetingScheduleId: moim.scheduleId, moimReqDto: moimReqDto))
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
    )
}

extension DependencyValues {
    public var moimUseCase: MoimUseCase {
        get { self[MoimUseCase.self] }
        set { self[MoimUseCase.self] = newValue }
    }
}
