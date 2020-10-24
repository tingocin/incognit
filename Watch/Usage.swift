import SwiftUI

struct Usage: View {
    @ObservedObject var delegate: Delegate
    @State private var since = ""
    @State private var alert = false
    
    var body: some View {
        VStack {
            Chart(values: delegate.chart)
                .padding(.horizontal)
            HStack {
                Text(verbatim: since)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Now")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }.padding(.horizontal)
            Button {
                alert = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.accentColor)
                    HStack {
                        Text("Forget")
                            .font(.headline)
                            .padding(.vertical)
                        Spacer()
                        Image(systemName: "flame")
                            .padding(.vertical)
                    }.padding(.horizontal)
                }
                .frame(height: 34)
                .contentShape(Rectangle())
            }.alert(isPresented: $alert) {
                Alert(title: .init("Forget everything?"), primaryButton: .default(.init("Cancel")), secondaryButton: .destructive(.init("Forget")) {
                    delegate.forget()
                })
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.black)
            .padding(.horizontal)
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
