import SwiftUI


struct AvatarView: View {
    let initials: String
    let color: Color
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
            Text(initials)
                .font(.system(size: size * 0.36, weight: .bold))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}


struct ToastView: View {
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.orange)
                .cornerRadius(50)
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)

            Spacer()
        }
        .padding(.top, 56)
        .frame(maxWidth: .infinity)
    }
}


struct PulseEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    scale = 1.15
                }
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseEffect())
    }
}

