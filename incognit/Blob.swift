import SwiftUI

struct Blob {
    struct Title: View {
        let title: LocalizedStringKey
        let action: () -> Void
        
        var body: some View {
            _Blob(content: Text(title)
                .font(.footnote)
                .bold(),
                  action: action)
        }
    }
    
    struct Icon: View {
        let icon: String
        let action: () -> Void
        
        var body: some View {
            _Blob(content:
                Image(systemName: icon)
                    .font(Font.headline.bold()), action: action)
        }
    }
}

private struct _Blob<Content>: View where Content : View {
    let content: Content
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            EmptyView()
        }.buttonStyle(Style { pressed in
            ZStack {
                Circle()
                    .frame(width: 45, height: 45)
                    .shadow(color: .init(.systemBackground), radius: 2, x: pressed ? 0 : -2, y: pressed ? 0 : -2)
                    .shadow(color: .init(.systemBackground), radius: 3, x: pressed ? 0 : 3, y: pressed ? 0 : 3)
                    .foregroundColor(pressed ? .pink : .init(.secondarySystemBackground))
                self.content
                    .foregroundColor(pressed ? .init(.systemBackground) : .pink)
            }
        })
    }
}

private struct Style<Content>: ButtonStyle where Content : View {
    var hover: (Bool) -> Content
    
    func makeBody(configuration: Configuration) -> some View {
        hover(configuration.isPressed)
    }
}
