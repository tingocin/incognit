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
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://ads.pubmatic.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": ".*googlesyndication.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://www.dianomi.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://vars.hotjar.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://contextual.media.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://imasdk.googleapis.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://platform.twitter.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://mafo.adalliance.io"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://ad.yieldlab.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": ".*adsystem.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://static.emsservice.de"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://cdn.flashtalking.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://gum.criteo.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://imagesrv.adition.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://us-u.openx.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://www.google.com/pagead/"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://interactive.guim.co.uk"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://js-sec.indexww.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://elb.the-ozone-project.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://www.googleadservices.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://googleads.g.doubleclick.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://s7.addthis.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://widgets.sparwelt.click"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://adstax-match.adrtx.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://aax-eu.amazon-adsystem.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://datawrapper.dwcdn.net"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://secure-assets.rubiconproject.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://eus.rubiconproject.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://ams.creativecdn.com"
    }
},
{
    "action": {
        "type": "block"
    },
    "trigger": {
        "url-filter": "https://www.youtube.com/embed"
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
