import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    //MARK: - Properties
    // viewModel environment object
    @EnvironmentObject var viewModel: MainViewModel
    
    //MARK: - ARView
    // create ARView, setup coaching, and subscribe to scene updates
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        // Coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        
        // Subscribe to SceneEvents.Update
        viewModel.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            updateScene(for: arView)
        })
        
        // debugging
//        arView.debugOptions.insert(.showStatistics)
        
        return arView
    }
    
    //MARK: - Update View
    func updateUIView(_ arView: CustomARView, context: Context) {
        takePicture(arView: arView)
        
        if viewModel.showingInfoSheet {
            arView.session.pause()
        } else {
            arView.configure()
        }
    }
    
    //MARK: - Take photo
    private func takePicture(arView: CustomARView) {
        if viewModel.takePicture {
            // take snapshot and save
            arView.snapshot(saveToHDR: false) { image in
                if let image = image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    viewModel.showingImageSavedAlert = true
                }
            }
            
            // reset picture state to false
            viewModel.takePicture = false
        }
    }
    
    //MARK: - Custom Scene Update
    private func updateScene(for arView: CustomARView) {
        enableFocusEntity(arView: arView)
        
        // place model if there is a model to be placed
        if viewModel.modelPlaced {
            if let pickedModel = viewModel.pickedModel, let modelEntity = pickedModel.rocketEntity {
                place(modelEntity, in: arView)

                viewModel.modelPlaced = false
            }
        }
        
        // delete all models
        if viewModel.deleteAllEntities {
            deleteAllEntities()
            
            viewModel.deleteAllEntities = false
        }
    }
    
    //MARK: - Focus entity
    private func enableFocusEntity(arView: CustomARView) {
        // focus entity is enabled if
            // the user selected to show it
            // there is a rocket picked
            // and is not taking a picture
        arView.focusEntity?.isEnabled = viewModel.showFocusIdentity && (viewModel.pickedModel != nil) && !viewModel.takePicture
    }
    
    //MARK: - Delete all entities in scene
    private func deleteAllEntities() {
        for anchorEntity in viewModel.allAnchors {
            anchorEntity.removeFromParent()
        }
        
        viewModel.allAnchors = []
    }
    
    //MARK: - Place entity in scene
    private func place(_ modelEntity: ModelEntity, in arView: CustomARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(clonedEntity)
        viewModel.allAnchors.append(anchorEntity)
        
        arView.scene.addAnchor(anchorEntity)
    }
}
