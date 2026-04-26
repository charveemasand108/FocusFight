import SwiftUI
import Combine

enum AppScreen {
    case lobby, battle, results
}

class GameViewModel: ObservableObject {

    // MARK: - Navigation
    @Published var screen: AppScreen = .lobby

    // MARK: - Lobby inputs
    @Published var taskText: String = ""
    @Published var selectedDuration: Int = 25   // minutes

    // MARK: - Battle state
    @Published var fighters: [Fighter] = []
    @Published var elapsedSeconds: Int = 0
    @Published var tokens: Int = 3
    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    @Published var playerWon: Bool = false
    @Published var playerEliminated: Bool = false

    var totalSeconds: Int { selectedDuration * 60 }
    var remainingSeconds: Int { max(0, totalSeconds - elapsedSeconds) }

    var timerString: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var isInDanger: Bool { remainingSeconds <= totalSeconds / 4 }

    // MARK: - Private
    private var timer: AnyCancellable?
    private var eliminationSchedule: [(index: Int, atSecond: Int)] = []

    // MARK: - Start Battle
    func startBattle() {
        fighters = [
            Fighter(id: "rahul", name: "Rahul", initials: "RK", color: Theme.blue),
            Fighter(id: "priya", name: "Priya",  initials: "PS", color: Theme.pink),
            Fighter(id: "arjun", name: "Arjun", initials: "AJ", color: Theme.green),
        ]
        elapsedSeconds = 0
        tokens = 3
        playerWon = false
        playerEliminated = false

        // Schedule opponents to break focus at 28%, 55%, 78% through
        let slots = [0.28, 0.55, 0.78]
        eliminationSchedule = fighters.indices.map { i in
            (index: i, atSecond: Int(slots[i] * Double(totalSeconds)))
        }

        screen = .battle

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    // MARK: - Tick
    private func tick() {
        guard !playerEliminated else { return }

        elapsedSeconds += 1

        // Update player health bar
        let progress = Double(elapsedSeconds) / Double(totalSeconds)
        // health stays full as long as you focus – it's the opponents who drop

        // Earn tokens every 90s
        let earned = 3 + (elapsedSeconds / 90)
        tokens = min(10, earned)

        // Check eliminations
        for schedule in eliminationSchedule {
            if !fighters[schedule.index].isEliminated,
               elapsedSeconds >= schedule.atSecond {
                eliminateOpponent(at: schedule.index)
            }
        }

        // Check if all opponents out → player wins
        if fighters.allSatisfy({ $0.isEliminated }) {
            endGame(won: true)
            return
        }

        // Time's up → player also wins (last one)
        if elapsedSeconds >= totalSeconds {
            endGame(won: true)
        }
    }

    // MARK: - Eliminate opponent
    private func eliminateOpponent(at index: Int) {
        let reason = breakReasons[index % breakReasons.count]
        fighters[index].isEliminated = true
        fighters[index].eliminatedAtSeconds = elapsedSeconds
        fighters[index].breakReason = reason
        fighters[index].focusHealth = 0.0
        showToast("\(fighters[index].name) \(reason)! Out 😂")
    }

    // MARK: - Sabotage
    func useSabotage(_ sabotage: Sabotage) {
        guard sabotage.cost <= tokens else { return }
        tokens -= sabotage.cost
        showToast(sabotage.message)
    }

    // MARK: - Surrender
    func surrender() {
        playerEliminated = true
        endGame(won: false)
    }

    // MARK: - End game
    private func endGame(won: Bool) {
        timer?.cancel()
        timer = nil
        playerWon = won
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.screen = .results
        }
    }

    // MARK: - Toast helper
    func showToast(_ msg: String) {
        toastMessage = msg
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { self.showToast = false }
        }
    }

    // MARK: - Reset to lobby
    func goToLobby() {
        timer?.cancel()
        timer = nil
        screen = .lobby
    }

    // MARK: - Formatted elapsed for results
    func timeString(for seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    // MARK: - Prize pool (mock)
    var prizePool: Int {
        sampleBets.reduce(0) { $0 + $1.amount }
    }
}

