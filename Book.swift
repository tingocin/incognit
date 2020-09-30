import SwiftUI

struct Book: View {
    @Binding var session: Session
    @State private var forget = false
    @State private var settings = false
    @State private var pages = [Page]()
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                Text("incognit")
                    .font(.headline)
                    .padding()
            }.foregroundColor(.init(.quaternaryLabel))
            ScrollView {
                Spacer()
                    .frame(height: 20)
                ForEach(pages) { page in
                    Item(page: page) {
                        session.delete(page)
                    } action: {
                        UIApplication.shared.resign()
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.page = page
                        }
                        page.date = .init()
                        session.save.send(page)
                    }
                }
                Spacer()
                    .frame(height: 80)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Control.Circle(selected: false, image: "eyeglasses") {
                        UIApplication.shared.resign()
                        forget = true
                    }.sheet(isPresented: $forget) {
                        Forget(session: $session, visible: $forget)
                    }
                    Bar(session: $session)
                    Control.Circle(selected: false, image: "gearshape.fill") {
                        UIApplication.shared.resign()
                        settings = true
                    }.sheet(isPresented: $settings) {
                        Settings(session: $session, visible: $settings)
                    }
                    Spacer()
                }
            }
        }.onReceive(session.pages) { new in
            withAnimation(pages.isEmpty ? .none : .easeInOut(duration: 0.3)) {
                pages = new.sorted { $0.date > $1.date }
            }
        }.transition(.move(edge: .top))
    }
}
