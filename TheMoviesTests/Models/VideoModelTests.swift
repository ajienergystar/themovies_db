//
//  VideoModelTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("Video Models")
struct VideoModelTests {

    @Test("Video decodes from API JSON")
    func decodeVideo() throws {
        let video = try TestFixtures.sampleVideo
        #expect(video.key == "dQw4w9WgXcQ")
        #expect(video.site == "YouTube")
        #expect(video.type == "Trailer")
    }

    @Test("isYouTubeTrailer is case insensitive")
    func isYouTubeTrailer() throws {
        let video = try TestFixtures.sampleVideo
        #expect(video.isYouTubeTrailer == true)

        let json = TestFixtures.videoJSON
            .replacingOccurrences(of: "\"type\": \"Trailer\"", with: "\"type\": \"Teaser\"")
        let teaser = try TestFixtures.decode(Video.self, from: json)
        #expect(teaser.isYouTubeTrailer == false)
    }

    @Test("embedURL builds YouTube embed URL")
    func embedURL() throws {
        let video = try TestFixtures.sampleVideo
        #expect(video.embedURL?.absoluteString == TMDBConstants.youtubeEmbedBaseURL + "dQw4w9WgXcQ")
    }

    @Test("VideoListResponse decodes results array")
    func decodeVideoList() throws {
        let response = try TestFixtures.videoListResponse
        #expect(response.results.count == 2)
        #expect(response.results.first?.isYouTubeTrailer == true)
        #expect(response.results.last?.isYouTubeTrailer == false)
    }
}
