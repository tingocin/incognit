import SwiftUI
import Combine

struct Book: View {
    @Binding var session: Session
    @State private var size = Bar.Size.small
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                Text("incognit")
                    .font(.headline)
            }.foregroundColor(.init(.quaternaryLabel))
            ScrollView {
                Spacer()
                    .frame(height: 40)
                ForEach(session.pages.sorted { $0.date > $1.date }) { page in
                    Item(page: page) {
                        session.refresh(page.id)
                        select(page.id)
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Bar(size: size) {
                        withAnimation {
                            size = .full
                        }
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
                    Control.Circle(image: "eyeglasses") {
                        
                    }
                    Control.Circle(image: "gearshape.fill") {
                        
                    }
                    Spacer()
                }
            }
        }.transition(.move(edge: .top))
        .onAppear {
            guard session.pages.isEmpty else { return }
            var sub: AnyCancellable?
            sub = session.balam.nodes(Page.self).sink {
                session.pages = .init($0)
                sub?.cancel()
            }
        }
    }
    
    private func select(_ id: UUID) {
        withAnimation(.easeInOut(duration: 1)) {
            session.current = id
        }
    }
}
