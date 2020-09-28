import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var options = false
    @State private var left = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Move(session: $session)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Spring {
                        options = true
                    } tabs: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.page = nil
                        }
                    }.sheet(isPresented: $options) {
                        Options(session: $session, visible: $options)
                    }.padding(.trailing)
                }
                HStack {
                    Spacer()
                    Bar(session: $session)
                    Spacer()
                }
            }
        }
    }
}
