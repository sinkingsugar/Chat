//
//  AttachmentsEditor.swift
//  Chat
//
//  Created by Alex.M on 22.06.2022.
//

import SwiftUI
import ActivityIndicatorView

struct AttachmentsEditor<InputViewContent: View, AlbumSelectionContent: View, CameraSelectionContent: View>: View {

    typealias InputViewBuilderClosure = ChatView<EmptyView, InputViewContent, DefaultMessageMenuAction>.InputViewBuilderClosure

    @Environment(\.chatTheme) var theme
    @Environment(\.mediaPickerTheme) var pickerTheme

    @EnvironmentObject private var keyboardState: KeyboardState
    @EnvironmentObject private var globalFocusState: GlobalFocusState

    @ObservedObject var inputViewModel: InputViewModel

    var inputViewBuilder: InputViewBuilderClosure?
    var chatTitle: String?
    var messageUseMarkdown: Bool
    var orientationHandler: MediaPickerOrientationHandler
    var mediaPickerSelectionParameters: MediaPickerParameters?
    var availableInput: AvailableInputType

    @State private var seleсtedMedias: [Media] = []
    @State private var currentFullscreenMedia: Media?

    var showingAlbums: Bool {
        inputViewModel.mediaPickerMode == .albums
    }

    public var body: some View {
        ZStack {
            mediaPicker
            if inputViewModel.showActivityIndicator {
                ActivityIndicator()
            }
        }
    }

    private var mediaPicker: some View {
        GeometryReader { geometry in
            mediaPickerContent(geometry)
        }
    }

    private func mediaPickerContent(_ geometry: GeometryProxy) -> some View {
        MediaPicker(isPresented: $inputViewModel.showPicker) {
            seleсtedMedias = $0
            assembleSelectedMedia()
        } albumSelectionBuilder: { mode, albumSelectionView, cancelClosure in
            AnyView(albumSelectionContainer(geometry, mode: mode, albumSelectionView: albumSelectionView, cancelClosure: cancelClosure))
        } cameraSelectionBuilder: { mode, cancelClosure, cameraSelectionView in
            AnyView(cameraSelectionContainer(geometry, mode: mode, cancelClosure: cancelClosure, cameraSelectionView: cameraSelectionView))
        }
        .didPressCancelCamera {
            inputViewModel.showPicker = false
        }
        .currentFullscreenMedia($currentFullscreenMedia)
        .showLiveCameraCell()
        .setSelectionParameters(mediaPickerSelectionParameters)
        .pickerMode($inputViewModel.mediaPickerMode)
        .orientationHandler(orientationHandler)
        .padding(.top)
        .background(pickerTheme?.main.albumSelectionBackground ?? .black)
        .ignoresSafeArea(.all)
        .onChange(of: currentFullscreenMedia) { newValue in
            assembleSelectedMedia()
        }
        .onChange(of: inputViewModel.showPicker) { _ in
            let showFullscreenPreview = mediaPickerSelectionParameters?.showFullscreenPreview ?? true
            let selectionLimit = mediaPickerSelectionParameters?.selectionLimit ?? 1

            if selectionLimit == 1 && !showFullscreenPreview {
                assembleSelectedMedia()
                inputViewModel.send()
            }
        }
    }

    private func albumSelectionContainer(_ geometry: GeometryProxy, mode: MediaPickerMode, albumSelectionView: AlbumSelectionContent, cancelClosure: @escaping () -> Void) -> some View {
        VStack {
            albumSelectionHeaderView
                .padding(.top, geometry.safeAreaInsets.top)
            albumSelectionView
            Spacer()
            inputView
                .padding(.bottom, geometry.safeAreaInsets.bottom)
        }
        .background(pickerTheme?.main.albumSelectionBackground ?? .black)
        .ignoresSafeArea()
    }

    private func cameraSelectionContainer(_ geometry: GeometryProxy, mode: MediaPickerMode, cancelClosure: @escaping () -> Void, cameraSelectionView: CameraSelectionContent) -> some View {
        VStack {
            cameraSelectionHeaderView(cancelClosure: cancelClosure)
                .padding(.top, geometry.safeAreaInsets.top)
            cameraSelectionView
            Spacer()
            inputView
                .padding(.bottom, geometry.safeAreaInsets.bottom)
        }
        .ignoresSafeArea()
    }

    private func assembleSelectedMedia() {
        if !seleсtedMedias.isEmpty {
            inputViewModel.attachments.medias = seleсtedMedias
        } else if let media = currentFullscreenMedia {
            inputViewModel.attachments.medias = [media]
        } else {
            inputViewModel.attachments.medias = []
        }
    }

    @ViewBuilder
    private var inputView: some View {
        Group {
            if let inputViewBuilder = inputViewBuilder {
                inputViewBuilder($inputViewModel.text, inputViewModel.attachments, inputViewModel.state, .signature, inputViewModel.inputViewAction()) {
                    globalFocusState.focus = nil
                }
            } else {
                InputView(
                    viewModel: inputViewModel,
                    inputFieldId: UUID(),
                    style: .signature,
                    availableInput: availableInput,
                    messageUseMarkdown: messageUseMarkdown
                )
            }
        }
    }

    private var albumSelectionHeaderView: some View {
        ZStack {
            HStack {
                Button {
                    seleсtedMedias = []
                    inputViewModel.showPicker = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            HStack {
                Text("Recents")
                Image(systemName: "chevron.down")
                    .rotationEffect(Angle(radians: showingAlbums ? .pi : 0))
            }
            .foregroundColor(.white)
            .onTapGesture {
                withAnimation {
                    inputViewModel.mediaPickerMode = showingAlbums ? .photos : .albums
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }

    private func cameraSelectionHeaderView(cancelClosure: @escaping ()->()) -> some View {
        HStack {
            Button {
                cancelClosure()
            } label: {
                theme.images.mediaPicker.cross
            }
            .padding(.trailing, 30)

            if let chatTitle = chatTitle {
                theme.images.mediaPicker.chevronRight
                Text(chatTitle)
                    .font(.title3)
                    .foregroundColor(theme.colors.textMediaPicker)
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
