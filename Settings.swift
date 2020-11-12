import SwiftUI
import CoreLocation

struct Settings: View {
    @Binding var session: Session
    @State private var location = LocalizedStringKey("")
    @State private var engine = User.engine
    @State private var secure = User.secure
    @State private var popups = User.popups
    @State private var javascript = User.javascript
    @State private var ads = User.ads
    @State private var trackers = User.trackers
    @State private var cookies = User.cookies
    @State private var dark = User.dark
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            Text("Search engine")
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
                    Toggle("Force dark mode", isOn: $dark)
                    Toggle("Safe browsing", isOn: $secure)
                    Toggle("Block trackers", isOn: $trackers)
                    Toggle("Block cookies", isOn: $cookies)
                    Toggle("Block pop-ups", isOn: $popups)
                    Toggle("Allow JavaScript", isOn: $javascript)
                    Toggle("Remove ads", isOn: $ads)
                }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                Section(footer:
                            HStack {
                                Text("You can make incognit your default browser and be secure and with privacy at all times.")
                                Spacer()
                            }) {
                    Button(action: {
                        UIApplication.shared.settings()
                    }) {
                        Text("Default browser")
                            .foregroundColor(.primary)
                    }
                }
                Section(footer:
                            VStack {
                                HStack {
                                    Text(location)
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack {
                                    Text("Websites may want to access your location to provide maps or navigation.\nYou can enable access to your location when needed and later remove the access.\nWe don't access your location at all.")
                                    Spacer()
                                }
                            }) {
                    Button(action: {
                        UIApplication.shared.settings()
                    }) {
                        Text("Privacy settings")
                            .foregroundColor(.primary)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
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
            switch CLLocationManager().authorizationStatus {
            case .denied, .restricted, .notDetermined: location = "No one can access your location"
            default: location = "Website can access your location"
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
        .onChange(of: dark) {
            User.dark = $0
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
