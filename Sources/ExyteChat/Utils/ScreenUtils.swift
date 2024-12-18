import SwiftUI

struct ScreenUtils {
    static let defaultVisionWidth: CGFloat = 1280
    static let defaultVisionHeight: CGFloat = 720
    
    @MainActor
    static func mainBounds() -> CGRect {
        #if os(iOS) || os(tvOS)
            return UIScreen.main.bounds
        #elseif os(macOS)
            return NSScreen.main?.visibleFrame ?? .zero
        #elseif os(visionOS)
            return .init(x: 0, y: 0, width: defaultVisionWidth, height: defaultVisionHeight)
        #else
            return .zero
        #endif
    }
    
    @MainActor
    static var width: CGFloat {
        mainBounds().width
    }
    
    @MainActor
    static var height: CGFloat {
        mainBounds().height
    }
    
    struct DynamicWidth: ViewModifier {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        
        let percentage: CGFloat
        
        func body(content: Content) -> some View {
            GeometryReader { geometry in
                content
                    .frame(maxWidth: geometry.size.width * percentage)
            }
        }
    }
}

extension View {
    func dynamicWidth(_ percentage: CGFloat = 1.0) -> some View {
        modifier(ScreenUtils.DynamicWidth(percentage: percentage))
    }
} 