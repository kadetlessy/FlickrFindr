//
//  PhotoListView.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import SwiftUI

struct PhotoListView: View {
    @ObservedObject var viewModel: PhotoListViewModel = PhotoListViewModel()
    var body: some View {
        List {
                ForEach(0..<viewModel.photos.count, id: \.self) { i in
                    NavigationLink(destination: PhotoDetailView(photo: viewModel.photos[i])) {
                        HStack {
                            URLImage(url: viewModel.photos[i].thumbnailUrl)
                                .frame(width: 50, height: 50)
                            Text(viewModel.photos[i].title)
                        }
                    }
                }
                
                if self.viewModel.isLoadMoreAvailable() {
                    Text("Fetching more...")
                        .onAppear(perform: {
                            viewModel.loadMorePhotos()
                        })
                }
        }
        .searchable(text: $viewModel.searchTerm)
        .onSubmit(of: .search) {
            viewModel.search()
        }
        .searchSuggestions {
            ForEach(viewModel.priorSearchTerms, id: \.self) { term in
                if term.lowercased().starts(with: viewModel.searchTerm.lowercased()) {
                    Text(term).searchCompletion(term)
                }
            }
        }
    }
}


struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
