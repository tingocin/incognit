import SwiftUI
import CoreLocation

struct Settings: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var location = LocalizedStringKey("")
    @State private var engine = User.engine
    @State private var secure = User.secure
    @State private var popups = User.popups
    @State private var javascript = User.javascript
    @State private var ads = User.ads
    @State private var trackers = User.trackers
    @State private var cookies = User.cookies
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            Text("Search Engine")
                            .padding(.top, 20)) {
                    Picker("", selection: $engine) {
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
                    Toggle("Safe Browsing", isOn: $secure)
                    Toggle("Block trackers", isOn: $trackers)
                    Toggle("Block cookies", isOn: $cookies)
                    Toggle("Block pop-ups", isOn: $popups)
                    Toggle("Allow JavaScript", isOn: $javascript)
                    Toggle("Remove ads", isOn: $ads)
                }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                Section(header:
                            Text("Privacy"),
                        footer:
                            VStack {
                                HStack {
                                    Text(location)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                Spacer()
                                    .frame(height: 6)
                                HStack {
                                    Text("Websites might want to access your location to provide maps or navigation.\n\nYou can enable access to your location when needed and then go to Privacy Settings and deny access, so that you can sure no one will be tracking you.\n\nWe don't access your location at all.")
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
        }.onChange(of: engine) {
            User.engine = $0
        }
        .onChange(of: secure) {
            User.secure = $0
        }
        .onChange(of: popups) {
            User.popups = $0
        }
        .onChange(of: javascript) {
            User.javascript = $0
        }
        .onChange(of: ads) {
            User.ads = $0
        }
        .onChange(of: trackers) {
            User.trackers = $0
        }
        .onChange(of: cookies) {
            User.cookies = $0
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
