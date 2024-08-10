//
//  SwiftUIView.swift
//  PracticeProject
//
//  Created by Mahesh on 29/02/24.
//

import SwiftUI

struct ImageExpandedView: View {
    
    var imgSelected : UIImage?
    
    var body: some View {
        NavigationStack{
            
            if let image = imgSelected{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 195*2)
                    .cornerRadius(20)
                    .padding(.horizontal)
            }else{
                Text("No data to display")
            }
        }
    }
}

#Preview {
ImageExpandedView()
}
