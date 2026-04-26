import SwiftUI

struct BattleView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var showSurrenderAlert = false

    var body: some View {
        VStack(spacing: 0) {

      
            SpectatorBar()

            ScrollView {
                VStack(spacing: 0) {

                   
                    HStack {
                        Text("FF")
                            .font(.custom("AvenirNext-Heavy", size: 20))
                            .foregroundColor(Theme.orange)
                            .kerning(3)
                        Spacer()
                        Text("ROUND 1")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Theme.textMuted)
                            .kerning(2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                  
                    Text(vm.timerString)
                        .font(.system(size: 76, weight: .black, design: .monospaced))
                        .foregroundColor(vm.isInDanger ? Theme.pink : Theme.textPrimary)
                        .animation(.easeInOut(duration: 0.3), value: vm.isInDanger)
                        .padding(.bottom, 4)

                 
                    HStack(spacing: 4) {
                        Text("Task:")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                        Text(vm.taskText.isEmpty ? "Stay focused" : vm.taskText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                    }
                    .padding(.bottom, 16)

                    Divider().background(Theme.border).padding(.horizontal, 20)

                    
                    VStack(spacing: 10) {
                     
                        YouFighterCard()

                        // Opponents grid
                        HStack(spacing: 10) {
                            ForEach(vm.fighters) { fighter in
                                OpponentCard(fighter: fighter)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                  
                    SabotagePanel()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)

                   
                    Button {
                        showSurrenderAlert = true
                    } label: {
                        Text("Surrender (you lose)")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.surface)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Theme.border, lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 36)
                }
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .alert("Surrender?", isPresented: $showSurrenderAlert) {
            Button("Yes, I give up", role: .destructive) { vm.surrender() }
            Button("Keep fighting", role: .cancel) {}
        } message: {
            Text("You'll be added to the Wall of Shame.")
        }
    }
}



struct SpectatorBar: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // Live dot
                Circle()
                    .fill(Theme.green)
                    .frame(width: 6, height: 6)
                    .overlay(
                        Circle().stroke(Theme.green.opacity(0.3), lineWidth: 4)
                            .scaleEffect(1.6)
                    )

                Text("12 watching")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textMuted)

                ForEach(sampleBets) { bet in
                    BetChip(bet: bet)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(hex: "#111111"))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Theme.border),
            alignment: .bottom
        )
    }
}

struct BetChip: View {
    let bet: SpectatorBet
    var body: some View {
        HStack(spacing: 3) {
            Text(bet.bettor)
                .foregroundColor(Theme.textMuted)
            Text("bet")
                .foregroundColor(Theme.textMuted)
            Text("₹\(bet.amount)")
                .foregroundColor(Theme.orange)
                .fontWeight(.semibold)
            Text("on \(bet.onFighter)")
                .foregroundColor(Theme.textMuted)
        }
        .font(.system(size: 11))
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Theme.surface)
        .cornerRadius(50)
        .overlay(RoundedRectangle(cornerRadius: 50).stroke(Theme.border, lineWidth: 0.5))
    }
}



struct YouFighterCard: View {
    @EnvironmentObject var vm: GameViewModel

    var progress: Double {
        1.0 - Double(vm.elapsedSeconds) / Double(vm.totalSeconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                AvatarView(initials: "YOU", color: Theme.orange, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text("You")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text(vm.playerEliminated ? "Surrendered 💀" : "Focused 🔥")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textMuted)
                }

                Spacer()

                Text("FIGHTING")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.orange)
                    .kerning(1.5)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.orange.opacity(0.12))
                    .cornerRadius(4)
            }

            HealthBar(progress: max(0, progress), color: Theme.orange)
        }
        .padding(14)
        .background(Theme.surface)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.orange, lineWidth: 1)
        )
    }
}



struct OpponentCard: View {
    let fighter: Fighter
    @EnvironmentObject var vm: GameViewModel

    var progress: Double {
        if fighter.isEliminated { return 0 }
        let ratio = Double(vm.elapsedSeconds) / Double(vm.totalSeconds)
        
        return max(0, 1.0 - ratio * 0.6)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                AvatarView(initials: fighter.initials, color: fighter.color, size: 34)
                VStack(alignment: .leading, spacing: 2) {
                    Text(fighter.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Text(fighter.isEliminated ? "Out 💀" : "Focused 💪")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                Spacer()
            }

            HealthBar(progress: progress, color: fighter.isEliminated ? Color.gray : fighter.color)
        }
        .padding(12)
        .background(Theme.surface)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.border, lineWidth: 0.5)
        )
        .opacity(fighter.isEliminated ? 0.45 : 1.0)
        .animation(.easeInOut(duration: 0.4), value: fighter.isEliminated)
    }
}



struct HealthBar: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.surface2)
                    .frame(height: 6)

                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: geo.size.width * progress, height: 6)
                    .animation(.linear(duration: 1), value: progress)
            }
        }
        .frame(height: 6)
    }
}


struct SabotagePanel: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("SABOTAGE")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Theme.textMuted)
                    .kerning(2)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.orange)
                    Text("\(vm.tokens) tokens")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.orange)
                }
            }

            HStack(spacing: 8) {
                ForEach(allSabotages) { sab in
                    SabotageButton(sabotage: sab) {
                        vm.useSabotage(sab)
                    }
                }
            }
        }
    }
}

struct SabotageButton: View {
    let sabotage: Sabotage
    let action: () -> Void
    @EnvironmentObject var vm: GameViewModel

    var canAfford: Bool { sabotage.cost <= vm.tokens }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: sabotage.icon)
                    .font(.system(size: 20))
                    .foregroundColor(canAfford ? Theme.textPrimary : Theme.textMuted)

                Text(sabotage.name)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)

                Text("\(sabotage.cost)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(canAfford ? Theme.orange : Color.gray)
                    .cornerRadius(4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.surface)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Theme.border, lineWidth: 0.5)
            )
            .opacity(canAfford ? 1.0 : 0.35)
        }
        .buttonStyle(.plain)
        .disabled(!canAfford)
    }
}

