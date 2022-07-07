//

import SwiftUI
import Combine
import RealityKit

class MainViewModel: ObservableObject {
    //MARK: - Properties
    // Index of the picked rocket
    @Published var pickedRocket: Int = 0
    // Selected model to place
    @Published var pickedModel: RocketModel? = nil
    // Toggle picker menu on/off
    @Published var showingPicker = true
    // Whether the selected model was placed or not (used to update view)
    @Published var modelPlaced = false
    // Hide focus entity
    @Published var showFocusIdentity = true
    // Delete all entities
    @Published var deleteAllEntities = false
    // All Anchors
    @Published var allAnchors: [AnchorEntity] = [] {
        didSet {
            if allAnchors.count == 3 {
                showingTooManyModelsAlert = true
            }
        }
    }
    // Showing info sheet
    @Published var showingInfoSheet = false
    // Take picture
    @Published var takePicture = false
    // Selected manufacturer
    @Published var selectedManufacturer = ""
    // Showing alert for too many models placed
    @Published var showingTooManyModelsAlert = false
    // Showing alert for image saved
    @Published var showingImageSavedAlert = false
    
    // Scene observer for arView scene updates
    var sceneObserver: Cancellable?
    
    // List of rockets, read from json file
    var rockets: [RocketModel] {
        var outputModels: [RocketModel] = []
        
        if let url = Bundle.main.url(forResource: "rockets", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode([RocketInfo].self, from: data)
                
                for rocket in jsonData {
                    outputModels.append(RocketModel(rocket: rocket))
                }
                
                return outputModels
            } catch {
                print("Error loading rockets data")
                print(error)
            }
        }
        
        return outputModels
    }
    
    // List of manufacturers
    var manufactures: [String] {
        var outputStrings: [String] = []
        
        for rocket in rockets {
            let shouldAdd = !outputStrings.contains(rocket.rocket.manufacturer)
            
            if shouldAdd {
                outputStrings.append(rocket.rocket.manufacturer)
            }
        }
        
        return outputStrings
    }
}
