import SwiftUI

public struct MediaPicker<AlbumSelectionContent: View, CameraSelectionContent: View>: View {
    @Binding var isPresented: Bool
    let onMediaPicked: ([Media]) -> Void
    let albumSelectionBuilder: ((MediaPickerMode, AlbumSelectionContent, @escaping () -> Void) -> AnyView)?
    let cameraSelectionBuilder: ((MediaPickerMode, @escaping () -> Void, CameraSelectionContent) -> AnyView)?
    
    @State private var mode: MediaPickerMode = .photos
    @State private var currentFullscreenMedia: Media?
    @State private var showLiveCamera: Bool = false
    @State private var selectionParams = SelectionParamsHolder()
    var orientationHandler: MediaPickerOrientationHandler = {_ in}
    
    public init(isPresented: Binding<Bool>,
                onMediaPicked: @escaping ([Media]) -> Void,
                albumSelectionBuilder: ((MediaPickerMode, AlbumSelectionContent, @escaping () -> Void) -> AnyView)? = nil,
                cameraSelectionBuilder: ((MediaPickerMode, @escaping () -> Void, CameraSelectionContent) -> AnyView)? = nil) {
        self._isPresented = isPresented
        self.onMediaPicked = onMediaPicked
        self.albumSelectionBuilder = albumSelectionBuilder
        self.cameraSelectionBuilder = cameraSelectionBuilder
    }
    
    public var body: some View {
        Text("Media Picker Placeholder")
            .onDisappear {
                orientationHandler(.unlock)
            }
    }
    
    public func currentFullscreenMedia(_ binding: Binding<Media?>) -> Self {
        var view = self
        view._currentFullscreenMedia = State(wrappedValue: binding.wrappedValue)
        return view
    }
    
    public func showLiveCameraCell() -> Self {
        var view = self
        view.showLiveCamera = true
        return view
    }
    
    public func setSelectionParameters(_ params: SelectionParamsHolder?) -> Self {
        var view = self
        if let params = params {
            view.selectionParams = params
        }
        return view
    }
    
    public func pickerMode(_ mode: Binding<MediaPickerMode>) -> Self {
        var view = self
        view._mode = State(wrappedValue: mode.wrappedValue)
        return view
    }
    
    public func orientationHandler(_ handler: @escaping MediaPickerOrientationHandler) -> Self {
        var view = self
        view.orientationHandler = handler
        return view
    }
    
    public func mediaSelectionLimit(_ limit: Int) -> Self {
        var view = self
        view.selectionParams.selectionLimit = limit
        return view
    }
    
    public func mediaSelectionType(_ type: MediaPickerMode) -> Self {
        var view = self
        view.mode = type
        return view
    }
    
    public func didPressCancelCamera(_ action: @escaping () -> Void) -> Self {
        self
    }
} 