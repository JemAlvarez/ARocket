import ARKit
import RealityKit
import FocusEntity // FocusEntity Packge - Max Cobb (maxxfrazer) - Package was used to show the user where the placement of the entity will occur

// Create a custom ARView to use the focus entity package
class CustomARView: ARView {
    var focusEntity: FocusEntity?
    
    // init with the ARView super init, configure, and create the focus entity
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        let config = ARWorldTrackingConfiguration()
        
        // Plane
        config.planeDetection = .horizontal
        
        // People occlusion
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics = .personSegmentationWithDepth
        }
        // Texturing
        config.environmentTexturing = .automatic
        
        session.run(config)
    }
}
