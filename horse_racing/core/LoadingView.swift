//
//  LoadingView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import SwiftUI

struct LoadingView: View {
    
    let text:String
    
    var body: some View {
        
        VStack(spacing:8){
            ProgressView()
                .tint(.primaryColor)
            Text(text)
        }
    }
}

struct LoadingView_Preview: PreviewProvider{
    static var previews: some View{
        LoadingView(text:"Loading")
    }
}
