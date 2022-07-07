//

import SwiftUI

struct RocketInfoView: View {
    @Environment(\.dismiss) var dismiss
    let rocket: RocketModel?
    
    @State var showingMissions = true
    
    var body: some View {
        if let _ = rocket {
            VStack(spacing: 20) {
                header()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        image()
                        
                        info()
                        
                        if !rocket!.rocket.importantMissions.isEmpty {
                            missions()
                        }
                        
                        credits()
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal)
        } else {
            ProgressView()
        }
    }
}

//MARK: - Preview
struct RocketInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RocketInfoView(rocket: .defaultRocket)
    }
}

//MARK: - Views
extension RocketInfoView {
    //MARK: - header
    func header() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 99, style: .continuous)
                .fill(.secondary)
                .frame(width: 80, height: 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(rocket!.rocket.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("Manufactured by: \(rocket!.rocket.manufacturer)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    ButtonView(image: "chevron.down")
                        .scaleEffect(0.75)
                }
            }
        }
        .padding(.top)
    }
    
    //MARK: - description
    func description() -> some View {
        Text(rocket!.rocket.description)
    }
    
    //MARK: - image
    func image() -> some View {
        Image("\(rocket!.rocket.id)")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(30)
    }
    
    //MARK: - info
    func info() -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Info")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                infoLabel(text: "First Launch: \(rocket!.rocket.firstLaunch)", systemImage: "calendar", with: .accentColor)
                
                infoLabel(text: "Height: \(rocket!.rocket.height) meters", systemImage: "ruler.fill", with: .blue)
                
                infoLabel(text: "Payload Capacity to LEO: \(rocket!.rocket.payloadCapacity) tons", systemImage: "scalemass.fill", with: .indigo)
                
                infoLabel(text: "Rocket Engine: \(rocket!.rocket.engine) Engine", systemImage: "hare.fill", with: .cyan)
                
                infoLabel(text: "Total Launches: \(rocket!.rocket.totalLaunches) launches", systemImage: "infinity", with: .orange)
                
                infoLabel(text: "Successful launches: \(rocket!.rocket.successfulLaunches) launches", systemImage: "checkmark", with: .green)
                
                infoLabel(text: "Stages: \(rocket!.rocket.stages)", systemImage: "square.split.2x2.fill", with: .pink)
            }
            .foregroundColor(.primary.opacity(0.8))
            .lineLimit(1)
        }
    }
    
    //MARK: - missions
    func missions() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Missions")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showingMissions.toggle()
                    }
                }) {
                    Image(systemName: "chevron.\(showingMissions ? "up" : "down")")
                }
            }
            
            if showingMissions {
                ForEach(rocket!.rocket.importantMissions.indices, id: \.self) { i in
                    VStack(alignment: .leading) {
                        Text(rocket!.rocket.importantMissions[i].name)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Date: \(rocket!.rocket.importantMissions[i].date)")
                            .font(.subheadline)
                            .foregroundColor(Color.primary.opacity(0.8))
                        
                        Text("Time: \(rocket!.rocket.importantMissions[i].time) GMT")
                            .font(.subheadline)
                            .foregroundColor(Color.primary.opacity(0.8))
                    }
                    .padding()
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(13)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    //MARK: - credits
    func credits() -> some View {
        VStack(spacing: 5) {
            Text("The 3D model used for this rocket was not created by me. It was downloaded from the internet with the Creative Commons License")
                .font(.footnote)
                .multilineTextAlignment(.center)
            
            Text("3D Model made by: \(rocket!.rocket.modelCreditCreator)")
                .font(.footnote)
            
            Link("3D Model Link", destination: URL(string: rocket!.rocket.modelCreditLink) ?? URL(string: "https://www.apple.com")!)
                .font(.footnote)
        }
    }
    
    //MARK: - Info label
    func infoLabel(text: String, systemImage: String, with color: Color = .primary) -> some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(color)
                .imageScale(.large)
                .frame(width: 35)
            
            Text(text)
                .foregroundColor(.primary.opacity(0.8))
            
            Spacer()
        }
        .lineLimit(1)
    }
}
