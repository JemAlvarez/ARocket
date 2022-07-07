//

import SwiftUI

struct ButtonView: View {
    let image: String
    
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 17, weight: .black))
            .imageScale(.large)
            .frame(width: 50, height: 50)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(image: "heart")
    }
}
