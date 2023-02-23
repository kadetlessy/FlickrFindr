//
//  PhotoSearchService.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import Foundation

protocol PhotoSearchServiceProtocol {
    func searchPhotos(for searchTerm: String, page: Int?) async throws -> Photos?
}

class PhotoSearchService: PhotoSearchServiceProtocol {
    private let apiKey = "1508443e49213ff84d566777dc211f2a"
    private let baseUrl = "https://api.flickr.com/services/rest/"

    func searchPhotos(for searchTerm: String, page: Int? = nil) async throws -> Photos? {
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        var urlString = "\(baseUrl)?method=flickr.photos.search&api_key=\(apiKey)&text=\(encodedSearchTerm)&per_page=25&format=json&nojsoncallback=1"
        if let page = page {
            urlString += "&page=\(page)"
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoSearchError.invalidResponse
        }
        let searchResponse = try JSONDecoder().decode(PhotoSearchResponse.self, from: data)
        return searchResponse.photos
    }
}

enum PhotoSearchError: Error {
    case invalidResponse
}
