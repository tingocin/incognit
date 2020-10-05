import SwiftUI
import CoreLocation

struct Settings: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var location = LocalizedStringKey("")
    
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
                Section(header:
                            Text("Privacy"),
                        footer:
                            VStack {
                                HStack {
                                    Text(location)
                                        .foregroundColor(.primary)
                                        .font(.footnote)
                                    Spacer()
                                }
                                HStack {
                                    Text("Websites might want to access your location to provide maps or navigation.\n\nYou can enable access to your location when needed and then go to Privacy Settings and deny access, so that you can sure no one will be tracking you.\n\nOurselves we don't access your location at all.")
                                    Spacer()
                                }
                            }) {
                    Button(action: {
                        UIApplication.shared.settings()
                    }) {
                        Text("Open Privacy Settings")
                            .foregroundColor(.primary)
                    }
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
        }.onAppear {
            switch CLLocationManager().authorizationStatus {
            case .denied, .restricted: location = "Location access denied"
            case .notDetermined: location = "Location access not determined"
            default: location = "Location access granted, you might want to change this"
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
