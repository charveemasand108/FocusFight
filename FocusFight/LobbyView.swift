import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var vm: GameViewModel

    let durations = [15, 25, 45, 60]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                
                VStack(spacing: 6) {
                    Text("FOCUSFIGHT")
                        .font(.custom("AvenirNext-Heavy", size: 52))
                        .foregroundColor(Theme.orange)
                        .kerning(4)

                    Text("PRODUCTIVITY AS A CONTACT SPORT")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Theme.textMuted)
                        .kerning(2)
                }
                .padding(.top, 60)
                .padding(.bottom, 36)

               
                VStack(alignment: .leading, spacing: 8) {
                    SectionLabel("YOUR MISSION")

                    TextField("e.g. Finish the pitch deck...", text: $vm.taskText)
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textPrimary)
                        .padding(14)
                        .background(Theme.surface2)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

             
                VStack(alignment: .leading, spacing: 8) {
                    SectionLabel("DURATION")

                    HStack(spacing: 8) {
                        ForEach(durations, id: \.self) { min in
                            DurationButton(
                                label: "\(min)m",
                                isSelected: vm.selectedDuration == min
                            ) {
                                vm.selectedDuration = min
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                
                VStack(alignment: .leading, spacing: 12) {
                    SectionLabel("FIGHTERS")

                    HStack(spacing: 10) {
                        FighterPill(initials: "YOU", name: "You",   color: Theme.orange)
                        FighterPill(initials: "RK",  name: "Rahul", color: Theme.blue)
                        FighterPill(initials: "PS",  name: "Priya", color: Theme.pink)
                        FighterPill(initials: "AJ",  name: "Arjun", color: Theme.green)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

              
                StakesCard()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

              
                Button {
                    vm.startBattle()
                } label: {
                    Text("START BATTLE")
                        .font(.custom("AvenirNext-Heavy", size: 24))
                        .kerning(3)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.orange)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .background(Theme.background.ignoresSafeArea())
    }
}


struct SectionLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(Theme.textMuted)
            .kerning(2)
    }
}

struct DurationButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .black : Theme.textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Theme.orange : Theme.surface2)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Theme.orange : Theme.border, lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

struct FighterPill: View {
    let initials: String
    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            AvatarView(initials: initials, color: color, size: 26)
            Text(name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.vertical, 6)
        .padding(.trailing, 10)
        .padding(.leading, 4)
        .background(Theme.surface2)
        .cornerRadius(50)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Theme.border, lineWidth: 0.5)
        )
    }
}

struct StakesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel("SPECTATOR BETS")

            ForEach(sampleBets) { bet in
                HStack {
                    Text(bet.bettor)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                    Text("bet ₹\(bet.amount) on")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                    Text(bet.onFighter)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.orange)
                    Spacer()
                }
            }

            Divider().background(Theme.border)

            HStack {
                Text("Total prize pool")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textMuted)
                Spacer()
                Text("₹\(sampleBets.reduce(0) { $0 + $1.amount })")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.orange)
            }
        }
        .padding(16)
        .background(Theme.surface)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.border, lineWidth: 0.5)
        )
    }
}

