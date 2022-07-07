//

import SwiftUI

struct RocketPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            topButtons()
            
            Spacer()
            
            bottomButtons()
            
            modelPicker()
        }
        .padding(.top)
        .sheet(isPresented: $viewModel.showingInfoSheet) { RocketInfoView(rocket: viewModel.pickedModel) }
    }
}


//MARK: - Preview
struct RocketPickerView_Preview: PreviewProvider {
    static var previews: some View {
        RocketPickerView()
            .environmentObject(MainViewModel())
            .preferredColorScheme(.dark)
    }
}

//MARK: - RocketPicker Views
extension RocketPickerView {
    //MARK: - Shrunk/Hidden model picker
    func shrunkModelPicker() -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        .frame(height: 10)
    }
    
    //MARK: - Model picker menu
    func modelPicker() -> some View {
        TabView(selection: $viewModel.pickedRocket) {
            ForEach(viewModel.rockets.indices, id: \.self) { i in
                let rocketMatches = (viewModel.rockets[i].rocket.manufacturer == viewModel.selectedManufacturer) || viewModel.selectedManufacturer == ""
                
                // display rockets by manufacturer
                if rocketMatches {
                    ZStack(alignment: .topLeading) {
                        // rocket selection info
                        VStack {
                            Text(viewModel.rockets[i].rocket.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("By: \(viewModel.rockets[i].rocket.manufacturer)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Image("\(viewModel.rockets[i].rocket.id)")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(30)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        // selection button
                        if viewModel.rockets[i].rocket.id != viewModel.pickedModel?.rocket.id ?? -1 {
                            Button(action: {
                                withAnimation(.spring()) {
                                    viewModel.pickedModel = viewModel.rockets[viewModel.pickedRocket]
                                }
                                if let pickedModel = viewModel.pickedModel {
                                    pickedModel.asyncLoadModelEntity()
                                }
                                withAnimation(.spring()) {
                                    viewModel.showingPicker = false
                                }
                            }) {
                                ButtonView(image: "checkmark")
                            }
                        }
                    }
                    .tag(viewModel.rockets[i].rocket.id)
                    .opacity(viewModel.showingPicker ? 1 : 0)
                }
            }
        }
        .padding([.top, .horizontal])
        .frame(height: viewModel.showingPicker ? 350 : 30)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: viewModel.showingPicker ? .always : .never))
        .background(.ultraThinMaterial)
    }
    
    //MARK: - Bottom Buttons
    func bottomButtons() -> some View {
        HStack {
            placementButtons()
            
            Spacer()
            
            sort()
            
            pickerToggle()
        }
        .padding(.horizontal)
    }
    
    // sorting button
    func sort() -> some View {
        Menu {
            ForEach(viewModel.manufactures, id: \.self) { manufacturer in
                Button(manufacturer) {
                    withAnimation(.spring()) {
                        viewModel.selectedManufacturer = manufacturer
                        viewModel.showingPicker = true
                    }
                }
            }
            
            Button("All") {
                withAnimation(.spring()) {
                    viewModel.selectedManufacturer = ""
                    viewModel.showingPicker = true
                }
            }
        } label: {
            ButtonView(image: "line.3.horizontal.decrease.circle.fill")
        }
    }
    
    // placement buttons
    func placementButtons() -> some View {
        Group {
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.pickedModel = nil
                    viewModel.showingPicker = true
                }
            }) {
                ButtonView(image: "xmark")
            }
            
            Button(action: {
                viewModel.modelPlaced = true
            }) {
                ButtonView(image: "hand.tap.fill")
            }
        }
        .opacity(viewModel.pickedModel != nil ? 1 : 0)
    }
    
    // picker menu toggle button
    func pickerToggle() -> some View {
        Button(action: {
            withAnimation(.spring()) {
                viewModel.showingPicker.toggle()
            }
        }) {
            ButtonView(image: "chevron.\(viewModel.showingPicker ? "down" : "up")")
        }
    }
    
    //MARK: - Top Buttons
    func topButtons() -> some View {
        HStack {
            cameraButton()
            
            infoButton()
            
            Spacer()
            
            if !viewModel.allAnchors.isEmpty {
                    deleteAllEntities()
            }
            
            if viewModel.pickedModel != nil {
                hideFocusEntity()
            }
        }
        .padding(.horizontal)
    }
    
    func cameraButton() -> some View {
        Button(action: {
            viewModel.takePicture = true
        }) {
            ButtonView(image: "camera.fill")
        }
    }
    
    func deleteAllEntities() -> some View {
        Button(action: {
            viewModel.deleteAllEntities = true
        }) {
            ButtonView(image: "trash.fill")
        }
        .transition(.opacity)
    }
    
    func infoButton() -> some View {
        Button(action: {
            viewModel.showingInfoSheet = true
        }) {
            ButtonView(image: "info")
        }
        .opacity(viewModel.pickedModel == nil ? 0 : 1)
    }
    
    func hideFocusEntity() -> some View {
        Button(action: {
            withAnimation {
                viewModel.showFocusIdentity.toggle()
            }
        }) {
            ButtonView(image: "viewfinder")
        }
        .transition(.opacity)
    }
}
