import SwiftUI

struct Usage: View {
    @ObservedObject var delegate: Delegate
    @State private var since = ""
    @State private var alert = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "eyeglasses")
                    .font(Font.title.bold())
                    .foregroundColor(.accentColor)
                Spacer()
                    .frame(height: 20)
                Chart(values: delegate.chart)
                    .frame(height: 100)
                HStack {
                    Text(verbatim: since)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Now")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.padding()
            Spacer()
                .frame(height: 20)
            Button {
                alert = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.accentColor)
                    HStack {
                        Text("Forget")
                            .font(.headline)
                            .padding()
                        Spacer()
                        Image(systemName: "flame")
                            .padding()
                    }.padding(.horizontal)
                }.contentShape(Rectangle())
            }.alert(isPresented: $alert) {
                Alert(title: .init("Forget everything?"), primaryButton: .default(.init("Cancel")), secondaryButton: .destructive(.init("Forget")) {
                    delegate.forget()
                })
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.primary)
            .padding()
        }
        .onAppear(perform: update)
        .onChange(of: delegate.chart) { _ in
            update()
        }
    }
    
    private func update() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .short
        since = formatter.string(from: delegate.since, to: .init())!
    }
}
