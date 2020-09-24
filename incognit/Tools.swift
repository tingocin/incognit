import SwiftUI
import Combine

struct Tools: View {
    @Binding var session: Session
    @State private var editing = ""
    @State private var hide = true
    @State private var tabsY = CGFloat()
    @State private var menuY = CGFloat()
    @State private var bottom = CGFloat()
    @State private var barWidth = CGFloat()
    @State private var subs = Set<AnyCancellable>()
    @State private var options = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Spacer()
                    Bar(text: $editing, width: barWidth, action: commit)
                    Spacer()
                }
                HStack {
                    Spacer()
                    ZStack {
                        Blob.Icon(icon: "square.on.square") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                session.current = nil
                            }
                        }.padding()
                            .offset(y: tabsY)
                        Blob.Icon(icon: "line.horizontal.3") {
                            self.show()
                            self.options = true
                        }.padding()
                            .offset(y: menuY)
//                            .sheet(isPresented: $options) {
//                                Options(url: self.$url, visible: self.$options)
//                        }
                        Blob.Icon(icon: hide ? "magnifyingglass" : "multiply", action: show)
                            .padding()
                    }
                    if hide {
                        Spacer()
                    }
                }
            }.offset(y: bottom)
        }.onAppear {
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).sink { notification in
                withAnimation {
                    self.bottom = -(notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                }
            }.store(in: &self.subs)
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).sink { notification in
                withAnimation {
                    self.bottom = 0
                }
            }.store(in: &self.subs)
        }
    }
    
    private func show() {
        if hide {
            withAnimation(Animation.linear(duration: 0.2)) {
                hide = false
                barWidth = 200
            }
            withAnimation(Animation.easeOut(duration: 0.2).delay(0.1)) {
                menuY = -75
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.1)) {
                tabsY = -150
            }
        } else {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            withAnimation(Animation.easeOut(duration: 0.2)) {
                tabsY = 0
                menuY = 0
            }
            withAnimation(Animation.linear(duration: 0.2).delay(0.1)) {
                barWidth = 0
                hide = true
            }
        }
    }
    
    private func commit() {
        show()
//        text = editing
    }
}
