import SwiftUI

struct Usage: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Chart(values: Shared.chart)
                        .frame(height: 140)
                    HStack {
                        Text(Shared.since, style: .relative)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Now")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                        .frame(height: 10)
                }.listRowBackground(Color(UIColor.systemBackground))
                Section {
                    Button {
                        withAnimation(.easeInOut(duration: 1)) {
                            session.forget()
                        }
                        UIApplication.shared.forget()
                        visible = false
                    } label: {
                        HStack {
                            Text("Forget")
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "flame")
                                .padding(.trailing)
                        }
                    }.foregroundColor(.primary)
                }
                Section(footer:
                            HStack {
                                Spacer()
                                Control.Icon(image: "arrow.down.circle.fill", color: .accentColor, font: .title) {
                                    visible = false
                                }.padding()
                                Spacer()
                            }) {
                    EmptyView()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Usage", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
