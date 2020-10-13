import WidgetKit
import SwiftUI

struct Log: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let items: [Shared.Item]
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Spacer()
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.black)
                if family != .systemLarge {
                    Spacer()
                        frame(height: 100)
                }
            } else {
                ForEach(0 ..< (family == .systemLarge ? items.count : 1)) {
                    if items[$0].open != nil && items[$0].url != nil {
                        Item(item: items[$0])
                    } else {
                        Placeholder(item: items[$0].title)
                    }
                }
            }
            Spacer()
        }.padding(.top)
    }
}

private struct Item: View {
    let item: Shared.Item
    
    var body: some View {
        Link(destination: item.open!) {
            Inner(title: item.title, url: item.url!.absoluteString)
        }
    }
}

private struct Placeholder: View {
    let item: String
    
    var body: some View {
        Inner(title: item, url: item)
            .redacted(reason: .placeholder)
    }
}


private struct Inner: View {
    let title: String
    let url: String
    
    var body: some View {
        VStack {
            HStack {
                Text(verbatim: title)
                    .lineLimit(1)
                    .font(Font.footnote.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            HStack {
                Text(verbatim: url)
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundColor(Color.black.opacity(0.7))
                Spacer()
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
