import SwiftUI

struct Book: View {
    @Binding var session: Session
    
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
                        select(page.id)
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Control.Circle(image: "plus.circle.fill", color: .accentColor) {
                        let page = Page()
                        _ = withAnimation {
                            session.pages.insert(page)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            select(page.id)
                        }
                    }.padding()
                    Control.Circle(image: "eyeglasses", color: .accentColor) {
                        
                    }.padding()
                    Control.Circle(image: "gearshape.fill", color: .accentColor) {
                        
                    }.padding()
                    Spacer()
                }
            }
        }.transition(.move(edge: .top))
    }
    
    private func select(_ id: UUID) {
        withAnimation(.easeInOut(duration: 0.5)) {
            session.current = id
        }
    }
}
