import SwiftUI
import WebKit

struct Settings: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            Text("Search Engine")
                            .padding(.top, 20)) {
                    Picker("", selection: $session.user.engine) {
                        Text("Ecosia")
                            .tag(Engine.ecosia)
                        Text("Google")
                            .tag(Engine.google)
                    }.pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                }
                Section(header:
                            Text("Options")
                            .padding(.top, 20)) {
                    Toggle("Safe Browsing", isOn: $session.user.secure)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Pop-ups", isOn: $session.user.popups)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("JavaScript", isOn: $session.user.javascript)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle("Ads (experimental)", isOn: $session.user.ads)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
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
            .navigationBarTitle("Settings", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
