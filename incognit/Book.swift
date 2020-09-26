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
                        session.refresh(page)
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
                    Bar(engine: session.engine, size: size) {
                        withAnimation {
                            size = .full
                        }
                        UIApplication.shared.textField.becomeFirstResponder()
                    } commit: {
                        guard let url = $0 else {
                            UIApplication.shared.resign()
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
    }
    
    private func select(_ id: UUID) {
        UIApplication.shared.resign()
        withAnimation(.easeInOut(duration: 5)) {
            session.current = id
        }
    }
}
