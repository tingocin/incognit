import SwiftUI

struct Book: View {
    @Binding var session: Session
    @State private var forget = false
    @State private var settings = false
    
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
                    .frame(height: 40)
                ForEach(session.pages.sorted { $0.date > $1.date }) { page in
                    Item(page: page) {
                        withAnimation {
                            session.delete(page)
                        }
                    } action: {
                        UIApplication.shared.resign()
                        withAnimation(.easeInOut(duration: 0.7)) {
                            session.page = page
                        }
                        page.date = .init()
                        session.save(page)
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
        }.onAppear {
            guard session.pages.isEmpty else { return }
            session.dispatch.async {
                let pages = FileManager.default.pages
                DispatchQueue.main.async {
                    session.pages = pages
                }
            }
        }.transition(.move(edge: .top))
    }
}
