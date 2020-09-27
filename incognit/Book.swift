import SwiftUI

struct Book: View {
    @Binding var session: Session
    @State private var size = Bar.Size.small
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
                        page.date = .init()
//                        session.balam.update(page)
                        select(page.id)
                    }
                }
                Spacer()
                    .frame(height: 80)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Control.Circle(image: "eyeglasses") {
                        UIApplication.shared.resign()
                        forget = true
                    }.sheet(isPresented: $forget) {
                        Forget(session: $session, visible: $forget)
                    }
                    Bar(session: $session, size: size) {
                        withAnimation {
                            size = .full
                        }
                        UIApplication.shared.textField.becomeFirstResponder()
                    } commit: {
                        UIApplication.shared.resign()
                        guard let url = $0 else {
                            withAnimation {
                                size = .small
                            }
                            return
                        }
                        let page = Page(url: url)
                        session.add(page)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            select(page.id)
                        }
                    }
                    Control.Circle(image: "gearshape.fill") {
                        UIApplication.shared.resign()
                        settings = true
                    }.sheet(isPresented: $settings) {
                        Settings(session: $session, visible: $settings)
                    }
                    Spacer()
                }
            }
        }.transition(.move(edge: .top))
        .onAppear {
            guard session.pages.isEmpty else { return }
            session.dispatch.async {
                let pages = FileManager.pages
                DispatchQueue.main.async {
                    session.pages = pages
                }
            }
        }
    }
    
    private func select(_ id: UUID) {
        withAnimation(.easeInOut(duration: 0.5)) {
            session.page = session.pages.first { $0.id == id }
        }
    }
}
