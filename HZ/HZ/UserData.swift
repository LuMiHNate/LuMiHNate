//
//  UserData.swift
//  HZ
//
//  Created by Matthew Soto on 5/14/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let display_name: String
    let country: String
    let images: [Image]
}

struct Image: Decodable {
    let url: String
}

struct SavedTracks: Decodable {
    let items: [SavedTrack]
    let total: Int
}

struct SavedTrack: Decodable {
    let track: TrackInfo
}

struct SavedAlbums: Decodable {
    let items: [SavedAlbum]
    let total: Int
}

struct SavedAlbum: Decodable {
    let album: AlbumInfo
}

struct SavedPlaylists: Decodable {
    let items: [SavedPlaylist]
    let total: Int
}

struct SavedPlaylist: Decodable {
    let external_urls: SpotifyLink
    let name: String
    let images: [ImageInfo]
    let id: String
}

struct TrackInfo: Decodable {
    let album: AlbumInfo
    let artists: [ArtistInfo]
    let external_urls: SpotifyLink
    let name: String
    let id: String
}

struct AlbumInfo: Decodable {
    let external_urls: SpotifyLink
    let name: String
    let artists: [ArtistInfo]
    let images: [ImageInfo]
    let id: String
}

struct ArtistInfo: Decodable {
    let external_urls: SpotifyLink
    let name: String
}

struct ImageInfo: Decodable {
    let url: String
}

struct SpotifyLink: Decodable {
    let spotify: String
}
