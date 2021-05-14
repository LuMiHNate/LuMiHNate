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

