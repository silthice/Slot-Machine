//
//  ContentView.swift
//  Slot Machine
//
//  Created by Giap on 18/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    //MARK: - BODY
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5, content: {
                //MARK: - HEADER
                LogoView()
                Spacer()
                
                //MARK: - SCORE
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("100")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                            
                    }  //: End of HStack
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("300")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }  //: End of HStack
                    .modifier(ScoreContainerModifier())
                    
                } //: End of HStack
                
                
                //MARK: - SLOT MACHINE
                VStack(alignment: .center, spacing: 0, content: {
                    //MARK: - REEL #1
                    ZStack {
                        ReelView()
                        Image("gfx-bell")
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        
                        //MARK: - REEL #2
                        ZStack {
                            ReelView()
                            Image("gfx-seven")
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        
                        Spacer()
                        
                        //MARK: - REEL #3
                        ZStack {
                            ReelView()
                            Image("gfx-cherry")
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    })
                    .frame(maxWidth: 500)
                    
                    
                    //MARK: - SPIN BUTTON
                    Button(action: {}, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                }) //: End of VStack
                .layoutPriority(2)
                
                
                //MARK: - FOOTER
                Spacer()
                
                HStack {
                    
                    
                    HStack(alignment: .center, spacing: 10) {
                        
                        //MARK: - BET 10
                        Button(action: {}, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(.yellow)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(1)
                            .modifier(CasinoChipModifier())
                        
                        //MARK: - BET 20
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(0)
                            .modifier(CasinoChipModifier())
                        
                        Button(action: {}, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        
                        
                    } //: End of HStack
                    
                    
                }
            }) //: End of VStack
            //MARK: - BUTTONS
            .overlay(
                Button(action: {}, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier())
                , alignment: .topLeading
            )
            .overlay(
                Button(action: {}, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier())
                , alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            
            //MARK: - POPUP
            
        } //: End of ZStack
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
