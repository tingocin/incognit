import SwiftUI

struct Usage: View {
    @Binding var session: Session
    @State private var since = ""
    @Environment(\.presentationMode) private var visible
    
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
                    visible.wrappedValue.dismiss()
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
                                        visible.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .frame(width: 40, height: 40)
                                            .contentShape(Rectangle())
                                    }))
        }.onAppear {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            since = formatter.string(from: Shared.since, to: .init())!
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
