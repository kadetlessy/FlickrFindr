//
//  PhotoDetailView.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ScrollView {
            URLImage(url: photo.fullUrl)
            .aspectRatio(contentMode: .fit)
            .gesture(MagnificationGesture())
        }
        .navigationBarTitle(photo.title, displayMode: .inline)
    }
    
    @Environment(\.presentationMode) var presentationMode
}

struct URLImage: View {
    let url: String
    @State private var imageData: Data?
    
    var body: some View {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(systemName: "photo")
                .onAppear(perform: downloadImage)
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
                return
            }
            print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}



struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: Photo())
    }
}
