//
//  PaywallView.swift
//  MacCatWall
//
//  Created by Andy Dent on 27/8/2025.
//

import SwiftUI

// MARK: - Paywall

struct PaywallView: View {
    enum Tab: String, CaseIterable {
        case subscriptions = "Subscriptions"
        case lifetime = "Lifetime"
    }
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
            case .lifetime: return "We know some folk hate subscriptions. Pay just $19.99 to have pro features forever."
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Tab = .subscriptions
    @State private var selectedPlan: Plan = .monthly
    
    var headerArt: some View {
        Image("PaywallHero")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 200.0)
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.accentColor)
                        .padding(0)
                }
                .background(.black)
                .buttonStyle(.plain)
                .padding(12)
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerArt
            
            ScrollView(showsIndicators: true) {
                VStack(alignment: .center, spacing: 12) {
                    
                    Text("Pro purrers do more with their designs")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle.bold())
                        .padding(.horizontal, 24)
                    
                    // Tabs
                    SegmentTabs(selected: $selectedTab)
                    /* would change to standard controls but cannot get color control so use generated segments
                     Picker("", selection: $selectedTab) {
                     Text("Subscriptions").tag(Tab.subscriptions)
                     Text("Lifetime").tag(Tab.lifetime)
                     }
                     .pickerStyle(SegmentedPickerStyle())*/
                    
                    // Feature list
                    Group {
                        FeatureRow(icon: "square.and.arrow.up", text: "Export code")
                        FeatureRow(icon: "square.and.pencil", text: "Add notes")
                        FeatureRow(icon: "puzzlepiece.extension", text: "Use advanced templates")
                        FeatureRow(icon: "play.circle", text: "Record video")
                    }
                    .tint(.outlineFeatures)
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
                            .font(.title.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .foregroundStyle(Color.demureBlue)
                            .background(Color.brightHighlight, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                    
                    // Footer links
                    HStack(spacing: 10) {
                        FooterLink(title: "Restore purchases") { restorePurchases() }
                        Text("•").foregroundStyle(.foreground.opacity(0.5))
                        FooterLink(title: "Terms and conditions") { openTerms() }
                        Text("•").foregroundStyle(.foreground.opacity(0.5))
                        FooterLink(title: "Privacy policy") { openPrivacy() }
                    }
                    .font(.body)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.systemBackground)
        }  // scroll
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

// mimics Picker.pickerStyle(SegmentedPickerStyle()) but with render control
private struct CapsuleTabs: View {
    @Binding var selected: PaywallView.Tab
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PaywallView.Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                        selected = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .foregroundStyle(selected == tab ? .demureBlue : .black)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .background(
                    ZStack {
                        if selected == tab {
                            RoundedRectangle(cornerRadius: 24).fill(.brightHighlight)
                                .padding(4)
                        }
                    }
                )
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray.opacity(0.35))
                .frame(height: 46)
        }
    }
}

private struct FeatureRow: View {
    var icon: String
    var text: String
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.outlineFeatures)
            Text(text)
                .font(.title2)
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
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                        .font(.title)
                        .foregroundStyle(isSelected ? .brightHighlight : .gray)
                    Text(plan.title)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Text(plan.subtitle)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.systemBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? .outlineFeatures : .gray, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
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
                .frame(width: 500, height: 800)               // pretend window size
                .previewLayout(.fixed(width: 900, height: 1400))
            
            PaywallView()
                .preferredColorScheme(.light)
                .frame(width: 400, height: 800)               // pretend window size
                .previewLayout(.fixed(width: 900, height: 1400))
        }
    }
}
