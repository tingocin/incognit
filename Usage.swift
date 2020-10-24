import SwiftUI

struct Usage: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var since = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                    .frame(height: 40)
                Chart(values: Shared.chart)
                    .frame(height: 200)
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
                Spacer()
                    .frame(height: 80)
                Button {
                    withAnimation(.easeInOut(duration: 1)) {
                        session.forget()
                    }
                    UIApplication.shared.forget()
                    visible = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.accentColor)
                            .frame(height: 50)
                        HStack {
                            Text("Forget")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "flame")
                        }.padding(.horizontal)
                    }.contentShape(Rectangle())
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                Spacer()
                    .frame(height: 20)
            }
            .navigationBarTitle("Usage", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        visible = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .frame(width: 40, height: 40)
                                            .contentShape(Rectangle())
                                    }))
        }.onAppear {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .short
            since = formatter.string(from: Shared.since, to: .init())!
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
