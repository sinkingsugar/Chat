import Foundation
import SwiftUI

public struct Media: Identifiable, Hashable {
    public let id: UUID
    public let type: MediaType
    public let url: URL
    public let thumbnail: URL?
    
    public init(id: UUID = UUID(), type: MediaType, url: URL, thumbnail: URL? = nil) {
        self.id = id
        self.type = type
        self.url = url
        self.thumbnail = thumbnail
    }
    
    public static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public func getThumbnailURL() async -> URL? {
        return thumbnail ?? url
    }

    public func getURL() async -> URL? {
        return url
    }
} 