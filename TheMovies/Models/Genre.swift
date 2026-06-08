//
//  Genre.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

struct GenreListResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable, Hashable {
    let id: Int
    let name: String
}
