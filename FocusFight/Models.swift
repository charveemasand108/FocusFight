import SwiftUI


struct Fighter: Identifiable {
    let id: String
    let name: String
    let initials: String
    let color: Color
    var isEliminated: Bool = false
    var eliminatedAtSeconds: Int? = nil
    var breakReason: String = ""
    var focusHealth: Double = 1.0   // 0.0 – 1.0
}

struct Sabotage: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let cost: Int
    let message: String
}

let allSabotages: [Sabotage] = [
    Sabotage(icon: "iphone.radiowaves.left.and.right", name: "Buzz",  cost: 1, message: "Buzz sent! 📳"),
    Sabotage(icon: "flame.fill",                       name: "Roast", cost: 2, message: "Roast delivered 🔥"),
    Sabotage(icon: "horn.blast.fill",                  name: "Horn",  cost: 2, message: "Air horn blasted! 📣"),
    Sabotage(icon: "atom",                             name: "Nuke",  cost: 3, message: "NUCLEAR meme sent ☢️"),
]


struct SpectatorBet: Identifiable {
    let id = UUID()
    let bettor: String
    let onFighter: String
    let amount: Int
}

let sampleBets: [SpectatorBet] = [
    SpectatorBet(bettor: "Meera",  onFighter: "You",   amount: 50),
    SpectatorBet(bettor: "Kiran",  onFighter: "Rahul",  amount: 100),
    SpectatorBet(bettor: "Dev",    onFighter: "Priya",  amount: 20),
    SpectatorBet(bettor: "Sneha",  onFighter: "Arjun",  amount: 75),
]


let breakReasons = [
    "Opened Instagram",
    "Checked WhatsApp",
    "Scrolled YouTube",
    "Opened Twitter/X",
    "Checked email",
    "Opened Zomato",
]

