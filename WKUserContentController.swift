import WebKit
import Tron

extension WKUserContentController {
    private static var cookies: WKContentRuleList?
    private static var ads: WKContentRuleList?
    
    func blockCookies() {
        if let cookies = Self.cookies {
            add(cookies)
        } else {
            WKContentRuleListStore.default()?.compileContentRuleList(forIdentifier: "cookies", encodedContentRuleList: Cookies.rule) { [weak self] list, _ in
                list.map {
                    Self.cookies = $0
                    self?.add($0)
                }
            }
        }
    }
    
    func blockAds() {
        if let ads = Self.ads {
            add(ads)
        } else {
            WKContentRuleListStore.default()?.compileContentRuleList(forIdentifier: "ads", encodedContentRuleList: Ads.serialise) { [weak self] list, _ in
                list.map {
                    Self.ads = $0
                    self?.add($0)
                }
            }
        }
    }
}
