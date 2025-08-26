# MacCatWall
Building a paywall for RevenueCat macOS SwiftUI.

As of [April 2025][rc1] there was no official paywall product for SwiftUI macOS apps.

This repo contains results of [asking ChatGPT5][gpt1] to generate SwiftUI code to match two existing screens and the refinement of that into a working app. The GPT session essentials are copied below with the code preserved in a separate subdirectory.

To simplify things, it's just being built as a macOS app.


## Paywall screenshots from iOS
These screenshots from the [Purrticles app][p1] on iOS were used to prompt chat.

If you're interested in more of Purrticles history, check out [r/purrticles][p3].


| **Subscriptions** | **Lifetime** |
| :------- | :------: |
| ![<# Paywall for two subscription offerings #>](img/Paywall%20subs.png "Paywall subs.png") | ![<# Paywall for lifetime purchase #>](img/Paywall.%20lifetime.png "Paywall. lifetime.png") |

### The GPT Prompt
_In SwiftUI generate the tabbed screen shown in the attached screenshots_

### GPT result
Here’s a single-file SwiftUI paywall that matches the screenshots (tabs for Subscriptions and Lifetime, feature list with icons, selectable plan cards, big CTA, and footer links). Drop this into your project as `PaywallView.swift` and present it modally.

See [source in git][gh1]

**Notes & hooks**

- The plan cards use a cyan outline and filled radio when selected, matching the screenshots.
- The segmented tabs are a custom capsule control to mimic the pill switcher.
- Replace the header gradient with your own artwork if you have one.
- Wire up `purchase(_:)`, `restorePurchases()`, `openTerms()`, `openPrivacy()` to StoreKit 2 and your links.

### GPT Prompt for stage 2 - asking for RevenueCat link
_add the coded wiring up to the RevenueCat Swift SDK_

Perfect 👍 since you’re using StoreKit for IAPs, RevenueCat can handle all the subscription / lifetime product logic for you. Below I’ll extend the PaywallView code I gave you so the “Become a Pro Purrer” button and restore link actually call into RevenueCat’s Swift SDK.

1. **Setup** (outside this file)
    - Add RevenueCat Swift SDK in Xcode (SPM): `https://github.com/RevenueCat/purchases-ios`
    - In your App initializer (e.g. AppDelegate or @main App), configure once:

```Swift
import RevenueCat

@main
struct MyApp: App {
    init() {
        Purchases.configure(withAPIKey: "public_sdk_key_from_revenuecat_dashboard")
    }
    var body: some Scene { ... }
}
```

- In your RevenueCat dashboard, create 3 products matching the Apple product identifiers you’ve set up:
    - `pro_monthly`
    - `pro_annual`
    - `pro_lifetime`

        
2. Hook into PaywallView

Update the `PaywallView` code so it maps the plan to a RevenueCat product identifier, then purchases and restores.

See [source in git][gh1]

3. Entitlements

* In RevenueCat dashboard, create an entitlement named pro.
* Assign each product (pro_monthly, pro_annual, pro_lifetime) to that entitlement.
* That way, you only check customerInfo.entitlements["pro"]?.isActive.

✅ With this, your SwiftUI paywall UI is fully wired to RevenueCat:

* Selecting a plan calls purchase(plan:) with the mapped product ID.
* The Restore purchases footer link calls restorePurchases().
* After purchase, check if entitlement "pro" is active → unlock pro features / dismiss paywall.


## Comments on the generated code
My mistake - one screenshot was scrolled so the heading "Pro purrers do more with\ntheir designs" only appears on one tab and the generated SwiftUI reflects that.

### Hero image
They don't replicate the common hero image but created code with a gradient roughly matching the colours instead.



[rc1]: https://community.revenuecat.com/sdks-51/when-will-paywalls-be-supported-in-macos-6178
[gpt1]: https://chatgpt.com/share/68ad9044-c144-8011-9c55-f3c335eb6227
[gh1]: https://github.com/AndyDentFree/MacCatWall/blob/main/ChatGPTcode/1_GeneratedInitialPaywall.swift
[gh2]: https://github.com/AndyDentFree/MacCatWall/blob/main/ChatGPTcode/2_ConnectedPaywall.swift

[p1]:  https://www.touchgram.com/purrticles
[p3]: https://www.reddit.com/r/purrticles/
