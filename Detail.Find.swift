import SwiftUI

extension Detail {
    struct Find: View {
        @Binding var session: Session
        @Binding var visible: Bool
        @State private var find = ""
        
        var body: some View {
            ZStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.init(.tertiaryLabel))
                        .frame(height: 1)
                }
                HStack {
                    ZStack {
                        if find.isEmpty {
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }
                        }
                        TextField("Find on Page", text: $find, onCommit: {
                            guard !find.isEmpty else { return }
                            visible = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                session.find.send(find)
                            }
                        }).textContentType(.URL)
                            .keyboardType(.webSearch)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal)
                    }
                    if !find.isEmpty {
                        Button(action: {
                            find = ""
                            UIApplication.shared.resign()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .padding()
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
        }
    }
}
