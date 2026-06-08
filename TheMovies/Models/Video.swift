//
//  Video.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

struct VideoListResponse: Decodable {
    let results: [Video]
}

struct Video: Decodable, Hashable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String

    var isYouTubeTrailer: Bool {
        site.lowercased() == "youtube" && type.lowercased() == "trailer"
    }

    var embedURL: URL? {
        URL(string: TMDBConstants.youtubeEmbedBaseURL + key)
    }
}
