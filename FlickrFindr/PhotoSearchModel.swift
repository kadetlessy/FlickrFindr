//
//  PhotoSearchModel.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import Foundation

struct PhotoSearchResponse: Codable {
    let photos: Photos
    //let stat: String
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    //let perpage: Int
    //let total: String
    let photo: [Photo]
}

struct Photo: Codable, Identifiable, Hashable {
    var id: String = "123"
    //let owner: String
    var secret: String = "123"
    var server: String = "123"
    var farm: Int = 1
    var title: String = "123"
//    let ispublic: Int
//    let isfriend: Int
//    let isfamily: Int
    var thumbnailUrl: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
    var fullUrl: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }
}
