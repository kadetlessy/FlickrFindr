//
//  PhotoListViewModel.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import Foundation

@MainActor class PhotoListViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var photos = [Photo]()
    @Published var priorSearchTerms = [String]()

    private let photoSearchService: PhotoSearchServiceProtocol
    private var currentPage: Int?
    private var numberOfPages: Int?

    init(photoSearchService: PhotoSearchServiceProtocol = PhotoSearchService()) {
        self.photoSearchService = photoSearchService
        loadPriorSearchTerms()
    }
    
    func search() {
        photos = []
        currentPage = nil
        numberOfPages = nil
        
        Task {
            do {
                if let photos = try await photoSearchService.searchPhotos(for: searchTerm, page: nil) {
                    await MainActor.run { [weak self] in
                        self?.photos = photos.photo
                        self?.numberOfPages = photos.pages
                        self?.currentPage = photos.page
                        self?.addSearchTermToPriorSearchTerms()
                    }
                }
            } catch {
                print("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }
    
    func isLoadMoreAvailable() -> Bool {
        guard let page = currentPage, let pages = numberOfPages else { return false }
        return page < pages
    }
    
    func loadMorePhotos() {
        guard let page = currentPage else { return }
        currentPage = page + 1
        Task {
            do {
                if let photos = try await photoSearchService.searchPhotos(for: searchTerm, page: currentPage) {
                    await MainActor.run { [weak self] in
                        self?.photos.append(contentsOf: photos.photo)
                    }
                }
            } catch {
                print("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }

    private func loadPriorSearchTerms() {
        priorSearchTerms = UserDefaults.standard.stringArray(forKey: "priorSearchTerms") ?? []
    }

    private func addSearchTermToPriorSearchTerms() {
        guard priorSearchTerms.firstIndex(of: searchTerm) == nil else { return }
        priorSearchTerms.insert(searchTerm, at: 0)
        UserDefaults.standard.set(priorSearchTerms, forKey: "priorSearchTerms")
    }
}
