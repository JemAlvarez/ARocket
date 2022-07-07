//

import SwiftUI
import RealityKit
import ARKit
import Combine

// ModeInfo - Decode JSON
struct RocketInfo: Codable {
    let id: Int
    let name: String
    let manufacturer: String
    let description: String
    let firstLaunch: String
    let height: Int
    let engine: String
    let totalLaunches: Int
    let successfulLaunches: Int
    let stages: Int
    let payloadCapacity: Double
    let importantMissions: [Mission]
    let scale: Float
    let modelCreditCreator: String
    let modelCreditLink: String
    
    struct Mission: Codable {
        let name: String
        let date: String
        let time: String
    }
}

// RocketModel - Rocket Info + Model Entity
class RocketModel {
    let rocket: RocketInfo
    var rocketEntity: ModelEntity?
    var cancellable: AnyCancellable?
    
    init(rocket: RocketInfo) {
        self.rocket = rocket
    }
    
    func asyncLoadModelEntity() {
        let fileName = "\(self.rocket.id).usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink { loadCompletion in
                switch loadCompletion {
                case .failure:
                    print("Failed to load model \(self.rocket.name)")
                case .finished:
                    break
                }
            } receiveValue: { entity in
                self.rocketEntity = entity
                self.rocketEntity?.transform.scale *= SIMD3<Float>(self.rocket.scale, self.rocket.scale, self.rocket.scale)
                print("Successfully loaded model \(self.rocket.name)")
            }
    }
}

// Default rocket model
extension RocketModel {
    static let defaultRocket = RocketModel(rocket: RocketInfo(
        id: 3,
        name: "Starship",
        manufacturer: "SpaceX",
        description: "Awesome rocket description here.",
        firstLaunch: "01/01/1970",
        height: 200,
        engine: "Merline",
        totalLaunches: 150,
        successfulLaunches: 149,
        stages: 2,
        payloadCapacity: 150,
        importantMissions: [
            RocketInfo.Mission(name: "Mission 1", date: "01/01/1970", time: "17:15"),
            RocketInfo.Mission(name: "Mission 2", date: "01/01/1970", time: "17:15")
        ],
        scale: 1,
        modelCreditCreator: "Awesome 3D model artist",
        modelCreditLink: "Link"
    ))
}
