//
//  ImageGalleryView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct ImageGalleryView: View {
    
    @StateObject var apiManager = APIManager()
    @State var isImageExpanded : Bool = false
    @State var imageSelected : UIImage?
    @EnvironmentObject var vm: ScannerViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationStack{
            ZStack{
                Color.main.ignoresSafeArea()
                if apiManager.imageArray.count != 0{
                    
                    ScrollView(.vertical){
                        LazyVGrid(columns: columns, alignment: .center, spacing: 0, content: {
                            withAnimation {
                                ForEach(apiManager.imageArray) { images in
                                    if let newImage = images.image{
                                        Image(uiImage: newImage)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .frame(height: 185)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        })
                    }.padding(.horizontal)
                }else{
                    Text("Loading...")
                }
            }.frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .task {
                    for _ in 1...200 {
                        await apiManager.loadImagesFromAPIUrl()
                    }
                }
                .navigationTitle("Gallery")
        }
    }
}

#Preview {
    ImageGalleryView()
}
