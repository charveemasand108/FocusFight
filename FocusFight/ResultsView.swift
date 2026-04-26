
import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var vm: GameViewModel

   
    var shameList: [(name: String, initials: String, color: Color, reason: String, seconds: Int)] {
        var list = vm.fighters
            .filter { $0.isEliminated }
            .compactMap { f -> (name: String, initials: String, color: Color, reason: String, seconds: Int)? in
                guard let t = f.eliminatedAtSeconds else { return nil }
                return (f.name, f.initials, f.color, f.breakReason, t)
            }
            .sorted { $0.seconds < $1.seconds }

        if !vm.playerWon {
            list.append(("You", "YOU", Theme.orange, "Surrendered early", vm.elapsedSeconds))
        }

        return list
    }

    var winnerName: String { vm.playerWon ? "You" : (vm.fighters.first(where: { !$0.isEliminated })?.name ?? "Rahul") }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

               
                VStack(spacing: 8) {
                    Text("🏆")
                        .font(.system(size: 56))
                        .padding(.top, 56)

                    Text("LAST ONE STANDING")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Theme.textMuted)
                        .kerning(2)

                    Text(winnerName.uppercased())
                        .font(.custom("AvenirNext-Heavy", size: 52))
                        .foregroundColor(Theme.orange)
                        .kerning(3)

                    if vm.playerWon {
                        Text("Survived \(vm.timeString(for: vm.elapsedSeconds)) · Won ₹\(vm.prizePool)")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textMuted)
                    } else {
                        Text("You surrendered at \(vm.timeString(for: vm.elapsedSeconds))")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.pink)
                    }
                }
                .padding(.bottom, 32)

                
                HStack(spacing: 0) {
                    StatBubble(label: "Duration", value: "\(vm.selectedDuration)m")
                    Divider().frame(width: 0.5).background(Theme.border)
                    StatBubble(label: "Fighters", value: "4")
                    Divider().frame(width: 0.5).background(Theme.border)
                    StatBubble(label: "Prize pool", value: "₹\(vm.prizePool)")
                }
                .background(Theme.surface)
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 0.5))
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

               
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("WALL OF SHAME")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Theme.textMuted)
                            .kerning(2)
                        Spacer()
                        Text("Broke first → last")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.bottom, 12)

                    if shameList.isEmpty {
                        Text("Everyone survived — legendary battle!")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textMuted)
                            .padding(.vertical, 16)
                    } else {
                        ForEach(Array(shameList.enumerated()), id: \.offset) { index, entry in
                            ShameRow(rank: index + 1, entry: entry)

                            if index < shameList.count - 1 {
                                Divider().background(Theme.border)
                            }
                        }
                    }

                   
                    if vm.playerWon {
                        Divider().background(Theme.border)
                        HStack(spacing: 14) {
                            Text("—")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Theme.orange)
                                .frame(width: 24)

                            AvatarView(initials: "YOU", color: Theme.orange, size: 34)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("You")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.orange)
                                Text("CHAMPION 🏆 · Won ₹\(vm.prizePool)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.orange.opacity(0.7))
                            }

                            Spacer()

                            Text("\(vm.selectedDuration):00")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(Theme.orange)
                        }
                        .padding(.vertical, 14)
                    }
                }
                .padding(16)
                .background(Theme.surface)
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 0.5))
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

               
                Button {
                    
                } label: {
                    Label("Share Wall of Shame", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.surface)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 0.5))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

               
                Button {
                    vm.goToLobby()
                } label: {
                    Text("PLAY AGAIN")
                        .font(.custom("AvenirNext-Heavy", size: 22))
                        .kerning(3)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.orange)
                        .cornerRadius(14)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 52)
            }
        }
        .background(Theme.background.ignoresSafeArea())
    }
}


struct StatBubble: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}



struct ShameRow: View {
    let rank: Int
    let entry: (name: String, initials: String, color: Color, reason: String, seconds: Int)

    var timeString: String {
        String(format: "%d:%02d", entry.seconds / 60, entry.seconds % 60)
    }

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.border)
                .frame(width: 24)

            AvatarView(initials: entry.initials, color: entry.color, size: 34)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Text(entry.reason + " at \(timeString)")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textMuted)
            }

            Spacer()

            Text(timeString)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.textMuted)
        }
        .padding(.vertical, 14)
    }
}

