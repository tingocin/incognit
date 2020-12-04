import SwiftUI

extension Book {
    struct Item: View {
        let page: Page
        let delete: () -> Void
        let action: () -> Void
        @State private var deleting = false
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    HStack {
                        VStack {
                            if !page.title.isEmpty {
                                HStack {
                                    Text(verbatim: page.title)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                            HStack {
                                Text(verbatim: page.url.absoluteString)
                                    .lineLimit(page.title.isEmpty ? 3 : 1)
                                    .font(.caption2)
                                    .foregroundColor(.init(.tertiaryLabel))
                                Spacer()
                            }
                        }.padding()
                    }
                    .opacity(deleting ? 0 : 1)
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .padding(.leading)
                            .opacity(deleting ? 1 : 0)
                        Spacer()
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onChanged { gesture in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                deleting = gesture.translation.width < -30
                            }
                        }
                        .onEnded {
                            guard $0.translation.width < -30 else {
                                withAnimation(.easeInOut(duration: 1)) {
                                    deleting = false
                                }
                                return
                            }
                            delete()
                        }
                )
            }
            .contentShape(Rectangle())
        }
    }
}
