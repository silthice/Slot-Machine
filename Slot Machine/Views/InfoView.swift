//
//  InfoView.swift
//  Slot Machine
//
//  Created by Giap on 19/01/2023.
//

import SwiftUI

struct InfoView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            LogoView()
            
            Spacer()
            
            Form {
                Section(content: {
                    FormRowView(item1: "Application", item2: "Slot Machine")
                    FormRowView(item1: "Platforms", item2: "iPhone, iPad, Mac")
                    FormRowView(item1: "Developer", item2: "Giap")
                    FormRowView(item1: "Designer", item2: "Giap")
                    FormRowView(item1: "Copyright", item2: "© 2023 All Rights Reserved")
                    FormRowView(item1: "Version", item2: "V1.0.0")
                }, header: {
                    Text("About the application")
                })
            } //: End of Form
            .font(.system(.body, design: .rounded))
        }) //: End of VStack
        .padding(.top, 40)
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })
            .padding(.top, 30)
            .padding(.trailing, 20)
            .tint(.secondary)
            , alignment: .topTrailing
        )
        
    }
}

struct FormRowView: View {
    var item1: String
    var item2: String
    
    var body: some View {
        HStack {
            Text(item1)
                .foregroundColor(.gray)
            Spacer()
            Text(item2)
        }
    }
}

//MARK: - PREVIEW
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
