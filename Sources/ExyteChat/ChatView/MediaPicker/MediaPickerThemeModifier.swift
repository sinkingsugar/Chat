import SwiftUI

public extension View {
    func mediaPickerTheme(main: MediaPickerTheme.Main, selection: MediaPickerTheme.Selection) -> some View {
        self.environment(\.mediaPickerTheme, MediaPickerTheme(main: main, selection: selection))
    }
} 