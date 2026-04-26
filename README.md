# ⚔️ FocusFight

> **Productivity as a contact sport.**

FocusFight is an iOS app that turns deep work into a multiplayer battle. You and your friends set tasks, lock in, and the last person to break focus wins the prize pool. Spectators watch live, place bets, and send sabotage attacks to throw you off.

---

## 🎮 How It Works

1. **Create a battle** — enter your task and choose a duration (15, 25, 45, or 60 minutes)
2. **Invite fighters** — friends join the same session
3. **Lock in** — everyone's phone locks out distractions; the timer starts
4. **Sabotage** — earn tokens by staying focused, spend them to buzz, roast, or nuke your opponents
5. **Last one standing wins** — the first to break focus gets added to the Wall of Shame

---

## ✨ Features

- 🔥 **Real-time focus battles** with up to 4 fighters
- 📊 **Live health bars** that drain as opponents lose focus
- ☢️ **Sabotage system** — Buzz, Roast, Air Horn, and Nuclear meme attacks
- 👀 **Spectator mode** — friends watch live and bet on who breaks first
- 🏆 **Wall of Shame** — timestamped leaderboard of exactly when and how everyone gave up
- 💰 **Prize pool** — winner takes the pot
- 🌑 **Dark mode native** — built for the aesthetic

---

## 🏗️ Architecture

~~~
FocusFightApp
    └── ContentView  (@StateObject GameViewModel)
            ├── LobbyView      → task input, duration, fighter list
            ├── BattleView     → timer, health bars, sabotage panel
            └── ResultsView    → winner reveal + Wall of Shame
~~~

**Pattern:** MVVM — all game logic lives in `GameViewModel` (`ObservableObject`). Views are purely reactive via `@EnvironmentObject`.

---

## 📂 File Structure

~~~
FocusFight/
├── FocusFightApp.swift      # App entry point (@main)
├── Theme.swift              # Colors, fonts, design tokens
├── Models.swift             # Fighter, Sabotage, SpectatorBet models
├── GameViewModel.swift      # Game logic, timer, state machine
├── ContentView.swift        # Screen router
├── LobbyView.swift          # Start screen
├── BattleView.swift         # Live battle screen
├── ResultsView.swift        # End screen + Wall of Shame
└── Components.swift         # Shared UI: AvatarView, ToastView
~~~

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| State | ObservableObject + @EnvironmentObject |
| Timer | Combine (`Timer.publish`) |
| Min iOS | iOS 16.0+ |
| Language | Swift 5.9 |

---

## 🗺️ Roadmap

- [ ] **Real multiplayer** — WebSocket server (Starscream + Node.js + Socket.io)
- [ ] **App locking** — Screen Time API (`FamilyControls` entitlement + `ManagedSettingsStore`)
- [ ] **Push notifications** — APNs for sabotage attacks on real devices
- [ ] **Real money** — RevenueCat + UPI/payment rails for the prize pool
- [ ] **Firebase** — live spectator feed, matchmaking, lobbies
- [ ] **Haptics** — `UIImpactFeedbackGenerator` on sabotage
- [ ] **Boss Battle mode** — community-wide 1,000-person focus events

---

## 💡 Concept

FocusFight was built around one insight: **social pressure is a better productivity tool than any app.** Nobody wants to be the first one out. Nobody wants their name on the Wall of Shame. Real stakes + real friends = actually getting stuff done.

Think Squid Game, but for procrastinators.

---
![image alt](https://github.com/charveemasand108/FocusFight/blob/81ad24ed79e69617530d39d6e35e855bdd875716/simulator_screenshot_739CC5C7-F753-4B19-8F22-9E722B616DF2.png)

## 👩‍💻 Author

**Charvee Masand** — [@charveemasand108](https://github.com/charveemasand108)

---

## 📄 License

MIT License — do whatever you want with it, just don't lose the focus battle.
