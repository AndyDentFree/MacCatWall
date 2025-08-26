import SwiftUI

// MARK: - Paywall

struct PaywallView: View {
    enum Tab: String, CaseIterable { case subscriptions = "Subscriptions", lifetime = "Lifetime" }
    enum Plan: Hashable {
        case monthly, annual, lifetime
        var title: String {
            switch self {
            case .monthly:  return "Monthly Plan"
            case .annual:   return "Annual Plan"
            case .lifetime: return "Pro forever"
            }
        }
        var subtitle: String {
            switch self {
            case .monthly:  return "Pro powers for $0.99/mo\nCancel any time."
            case .annual:   return "Pro powers for $7.99/yr ($0.67/mo)\nCancel any time."
            case .lifetime: return "We know some folk hate subscriptions. Pay just\n$19.99 to have pro features forever."
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Tab = .subscriptions
    @State private var selectedPlan: Plan = .monthly

    // Replace "HeaderArt" with your asset. A gradient placeholder is provided.
    var headerArt: some View {
        ZStack {
            LinearGradient(
                colors: [.orange.opacity(0.95), .cyan, .orange.opacity(0.95)],
                startPoint: .leading, endPoint: .trailing
            )
            .mask(
                HStack(spacing: 0) {
                    Rectangle().cornerRadius(4)
                    Rectangle().cornerRadius(4)
                    Rectangle().cornerRadius(4)
                }
            )
        }
        .frame(height: 210)
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(10)
                    .background(.black.opacity(0.45), in: Circle())
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {

                // Fake stacked cards behind the header (as in screenshots)
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(Color(.sRGB, white: 0.12, opacity: 1)).offset(y: -8)
                        .frame(height: 24)
                    RoundedRectangle(cornerRadius: 14).fill(Color(.sRGB, white: 0.16, opacity: 1)).offset(y: -4)
                        .frame(height: 24)
                }
                .frame(height: 0)

                headerArt

                if selectedTab == .lifetime {
                    Text("Pro purrers do more with\ntheir designs")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 18)
                        .padding(.horizontal, 24)
                }

                // Tabs
                SegmentTabs(selected: $selectedTab)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        // Feature list
                        FeatureRow(icon: "square.and.arrow.up", text: "Export code")
                        FeatureRow(icon: "pencil.and.outline", text: "Add notes")
                        FeatureRow(icon: "puzzlepiece.extension", text: "Use advanced templates")
                        FeatureRow(icon: "play.circle", text: "Record video")

                        // Plans
                        if selectedTab == .subscriptions {
                            PlanCard(plan: .monthly, selected: $selectedPlan)
                            PlanCard(plan: .annual, selected: $selectedPlan)
                        } else {
                            PlanCard(plan: .lifetime, selected: $selectedPlan)
                        }

                        // CTA
                        Button {
                            purchase(plan: selectedPlan)
                        } label: {
                            Text("Become a Pro Purrer")
                                .font(.system(size: 22, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .foregroundStyle(Color.black)
                                .background(Color.cyan, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                        }
                        .padding(.top, 6)

                        // Footer links
                        HStack(spacing: 10) {
                            FooterLink(title: "Restore purchases") { restorePurchases() }
                            Text("•").foregroundStyle(.white.opacity(0.5))
                            FooterLink(title: "Terms and conditions") { openTerms() }
                            Text("•").foregroundStyle(.white.opacity(0.5))
                            FooterLink(title: "Privacy policy") { openPrivacy() }
                        }
                        .font(.footnote)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            // switch the default selection when switching tabs
            if newValue == .subscriptions {
                if selectedPlan == .lifetime { selectedPlan = .monthly }
            } else {
                selectedPlan = .lifetime
            }
        }
    }

    // MARK: - Actions (hook up to StoreKit)
    private func purchase(plan: Plan) {
        // TODO: Integrate with StoreKit 2 products & purchases for your identifiers.
        print("Purchase:", plan.title)
    }
    private func restorePurchases() { print("Restore purchases") }
    private func openTerms() { print("Open terms") }
    private func openPrivacy() { print("Open privacy") }
}

// MARK: - Components

private struct SegmentTabs: View {
    @Binding var selected: PaywallView.Tab
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            CapsuleTabs(selected: $selected)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
        }
    }
}

private struct CapsuleTabs: View {
    @Binding var selected: PaywallView.Tab
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray.opacity(0.35))
                .frame(height: 46)

            HStack(spacing: 0) {
                ForEach(PaywallView.Tab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            selected = tab
                        }
                    } label: {
                        Text(tab.rawValue)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                    }
                    .foregroundStyle(selected == tab ? .black : .white.opacity(0.85))
                    .background(
                        ZStack {
                            if selected == tab {
                                RoundedRectangle(cornerRadius: 24).fill(Color.cyan)
                                    .padding(4)
                            }
                        }
                    )
                }
            }
        }
    }
}

private struct FeatureRow: View {
    var icon: String
    var text: String
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.cyan)
            Text(text)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.top, 2)
    }
}

private struct PlanCard: View {
    let plan: PaywallView.Plan
    @Binding var selected: PaywallView.Plan

    var isSelected: Bool { selected == plan }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { selected = plan }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Circle()
                        .stroke(Color.cyan, lineWidth: 2)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(isSelected ? Color.cyan : .clear)
                                .padding(4)
                        )
                    Text(plan.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                Text(plan.subtitle)
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.sRGB, white: 0.14, opacity: 1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.cyan.opacity(isSelected ? 1 : 0.4), lineWidth: 2)
                    )
            )
        }
    }
}

private struct FooterLink: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .underline(false)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaywallView()
                .preferredColorScheme(.dark)

            PaywallView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
