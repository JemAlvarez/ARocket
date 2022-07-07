//

import SwiftUI

struct AlertBubbleView: View {
    @Binding var showing: Bool
    let text: String
    
    var body: some View {
        VStack {
            VStack {
                Text(text)
            }
            .padding()
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 99, style: .continuous))
            .frame(maxWidth: 300)
            .multilineTextAlignment(.center)
            .offset(y: showing ? 0 : -200)
            .animation(.spring(), value: showing)
            
            Spacer()
        }
        .padding(.top)
        .onChange(of: showing) { _ in
            if showing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showing = false
                }
            }
        }
    }
}

struct AlertBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        AlertBubbleView(showing: .constant(true), text: "Text")
    }
}
