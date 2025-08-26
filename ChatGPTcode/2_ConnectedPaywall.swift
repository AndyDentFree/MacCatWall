import SwiftUI
import RevenueCat

struct PaywallView: View {
    // ... keep Tab and Plan enums ...

    // 👇 map your plans to RevenueCat product identifiers
    private func productID(for plan: Plan) -> String {
        switch plan {
        case .monthly:  return "pro_monthly"
        case .annual:   return "pro_annual"
        case .lifetime: return "pro_lifetime"
        }
    }

    // MARK: - Actions (RevenueCat wiring)

    private func purchase(plan: Plan) {
        let id = productID(for: plan)

        Purchases.shared.getProducts([id]) { products in
            guard let package = products.first else {
                print("⚠️ Couldn't find product \(id)")
                return
            }

            Purchases.shared.purchase(product: package) { transaction, customerInfo, error, userCancelled in
                if let error = error {
                    print("❌ Purchase failed:", error)
                    return
                }
                if userCancelled {
                    print("🛑 Purchase cancelled")
                    return
                }
                if let info = customerInfo {
                    if info.entitlements.all["pro"]?.isActive == true {
                        print("✅ Pro unlocked!")
                        // TODO: dismiss paywall or set user state
                    }
                }
            }
        }
    }

    private func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let error = error {
                print("❌ Restore failed:", error)
                return
            }
            if let info = customerInfo,
               info.entitlements.all["pro"]?.isActive == true {
                print("✅ Pro restored!")
                // TODO: dismiss paywall or set user state
            }
        }
    }

    private func openTerms() { /* open URL to terms */ }
    private func openPrivacy() { /* open URL to privacy */ }

    // ... rest of PaywallView unchanged ...
}
