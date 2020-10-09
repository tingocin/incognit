import Foundation

extension Web {
        static let json = """
[
    {
        "action": {
            "type": "block"
        },
        "trigger": {
            "url-filter": ".*dailymail.*"
        }
    },
    {
        "action": {
            "type": "css-display-none",
            "selector": "div[class*='card-ad']"
        },
        "trigger": {
            "url-filter": ".*"
        }
    },
    {
        "action": {
            "type": "css-display-none",
            "selector": "div[id='tvcap']"
        },
        "trigger": {
            "url-filter": ".*"
        }
    }
]
"""
}
