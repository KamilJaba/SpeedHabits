//
//  SHButton.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 24/01/2024.
//

import SwiftUI

struct SHButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

struct SHButton_Previews: PreviewProvider {
    static var previews: some View {
        SHButton(title: "Title", background: .red){
            //Action
        }
    }
}
