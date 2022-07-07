import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            ARViewContainer()
                .ignoresSafeArea()
            
            RocketPickerView()
            
            AlertBubbleView(showing: $viewModel.showingImageSavedAlert, text: "Photo saved to your gallery")
            
            AlertBubbleView(showing: $viewModel.showingTooManyModelsAlert, text: "Placing too many rockets can cause performance issues")
        }
        .environmentObject(viewModel)
    }
}
