import SwiftUI

struct Book: View {
    @Binding var session: Session
    @State private var pages = [Page]()
    
    var body: some View {
        Group {
            if pages.isEmpty {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(Color.accentColor)
            } else {
                ScrollView {
                    ForEach(pages) { page in
                        Item(page: page) {
                            session.delete(page)
                        } action: {
                            session.resign.send()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                session.page = page
                            }
                            page.date = .init()
                            session.save.send(page)
                        }
                    }
                    Spacer()
                        .frame(height: 80)
                }
            }
        }.onReceive(session.pages.receive(on: DispatchQueue.main)) {
            guard let new = $0 else { return }
            withAnimation(pages.isEmpty ? .none : .easeInOut(duration: 0.3)) {
                pages = new.sorted { $0.date > $1.date }
            }
        }
    }
}
