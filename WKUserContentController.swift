import WebKit

extension WKUserContentController {
    private static var cookies: WKContentRuleList?
    private static var ads: WKContentRuleList?
    
    func blockCookies() {
        if let cookies = Self.cookies {
            add(cookies)
        } else {
            WKContentRuleListStore.default()?.compileContentRuleList(forIdentifier: "cookies", encodedContentRuleList: Self._cookies) { [weak self] list, _ in
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
            WKContentRuleListStore.default()?.compileContentRuleList(forIdentifier: "ads", encodedContentRuleList: Self._ads) { [weak self] list, _ in
                list.map {
                    Self.ads = $0
                    self?.add($0)
                }
            }
        }
    }
    
    private static let _ads = """
[
{
    "action": {
        "type": "css-display-none",
        "selector": "div[class*='card-ad']"
    },
    "trigger": {
        "url-filter": "https://www.ecosia.org"
    }
},
{
    "action": {
        "type": "css-display-none",
        "selector": "div[class*='card-productads']"
    },
    "trigger": {
        "url-filter": "https://www.ecosia.org"
    }
},
{
    "action": {
        "type": "css-display-none",
        "selector": "div[id='taw']"
    },
    "trigger": {
        "url-filter": "https://www.google.com"
    }
},
{
    "action": {
        "type": "css-display-none",
        "selector": "div[id='rhs']"
    },
    "trigger": {
        "url-filter": "https://www.google.com"
    }
}
]
"""
    
    private static let _cookies = """
[
{
    "action": {
        "type": "block-cookies"
    },
    "trigger": {
        "url-filter": ".*"
    }
}
]
"""
}
