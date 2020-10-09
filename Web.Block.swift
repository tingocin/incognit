import Foundation

extension Web {
        static let json = """
[
    {
        "action": {
            "type": "block"
        },
        "trigger": {
            "url-filter": "https://www.googletagservices.com"
        }
    },
    {
        "action": {
            "type": "block"
        },
        "trigger": {
            "url-filter": "https://www.googletagservices.com"
        }
    },
    {
        "action": {
            "type": "block"
        },
        "trigger": {
            "url-filter": "https://pagead2.googlesyndication.com"
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
            "url-filter": "https://tags.crwdcntrl.net"
        }
    },
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
}
