//
//  FlickrFindrApp.swift
//  FlickrFindr
//
//  Created by Olesia on 23.02.2023.
//

import SwiftUI

@main
struct FlickrFindrApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PhotoListView()
                    .navigationBarTitle("Flickr Search")
            }
        }
    }
}
