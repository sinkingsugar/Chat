import SwiftUI

public enum MediaPickerMode {
    case photos
    case albums
    case camera
    case cameraSelection
}

public typealias MediaPickerOrientationHandler = (MediaPickerOrientation) -> Void

public enum MediaPickerOrientation {
    case lock
    case unlock
}

public struct SelectionParamsHolder {
    public var selectionLimit: Int = 1
    public var showFullscreenPreview: Bool = true
    
    public init() {}
}

// Environment key for media picker theme
private struct MediaPickerThemeKey: EnvironmentKey {
    static let defaultValue: MediaPickerTheme? = nil
}

public extension EnvironmentValues {
    var mediaPickerTheme: MediaPickerTheme? {
        get { self[MediaPickerThemeKey.self] }
        set { self[MediaPickerThemeKey.self] = newValue }
    }
}

// Media picker theme struct
public struct MediaPickerTheme {
    public struct Main {
        public var text: Color
        public var albumSelectionBackground: Color
        public var fullscreenPhotoBackground: Color
        
        public init(text: Color, albumSelectionBackground: Color, fullscreenPhotoBackground: Color) {
            self.text = text
            self.albumSelectionBackground = albumSelectionBackground
            self.fullscreenPhotoBackground = fullscreenPhotoBackground
        }
    }
    
    public struct Selection {
        public var emptyTint: Color
        public var emptyBackground: Color
        public var selectedTint: Color
        public var fullscreenTint: Color
        
        public init(emptyTint: Color, emptyBackground: Color, selectedTint: Color, fullscreenTint: Color) {
            self.emptyTint = emptyTint
            self.emptyBackground = emptyBackground
            self.selectedTint = selectedTint
            self.fullscreenTint = fullscreenTint
        }
    }
    
    public let main: Main
    public let selection: Selection
    
    public init(main: Main, selection: Selection) {
        self.main = main
        self.selection = selection
    }
} 