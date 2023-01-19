//
//  ContentView.swift
//  Slot Machine
//
//  Created by Giap on 18/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var showInfoView: Bool = false
    @State private var reels: Array = [0,1,2]
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "userHighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showGameoverModal: Bool = false
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    
    //MARK: - FUNCTIONS
    //SPIN
    func spins() {
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
        
        //mapping of each array
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        
        validateWin()
        gameover()
    }
    
    //WINNING VALIDATION
    func validateWin() {
        if reels[0] == reels [1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //WIN
            playerWins()
            //NEW HIGHSCORE
            if coins > highScore {
                newHighScore()
            }
        } else {
            //LOSE
            playerLoses()
            //GAME OVER
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }

    func newHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "userHighScore")
    }
    
    func playerLoses() {
        coins -= betAmount
    }

    func bet20() {
        betAmount = 20
    }
    
    func bet10() {
        betAmount = 10
    }
    
    func gameover() {
        if coins <= 0 {
            //SHOW MODAL
            showGameoverModal = true
        }
    }
    
    func reset() {
        highScore = 0
        coins = 100
        bet10()
        UserDefaults.standard.set(0, forKey: "userHighScore")
    }
    
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
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                            
                    }  //: End of HStack
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
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
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        
                        //MARK: - REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        
                        Spacer()
                        
                        //MARK: - REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    })
                    .frame(maxWidth: 500)
                    
                    
                    //MARK: - SPIN BUTTON
                    Button(action: {
                        spins()
                    }, label: {
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
                        Button(action: {
                            bet10()
                            isActiveBet10 = true
                            isActiveBet20 = false
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipModifier())
                        
                        //MARK: - BET 20
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipModifier())
                        
                        Button(action: {
                            bet20()
                            isActiveBet20 = true
                            isActiveBet10 = false
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        
                        
                    } //: End of HStack
                    
                    
                }
            }) //: End of VStack
            //MARK: - BUTTONS
            .overlay(
                Button(action: {
                    reset()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier())
                , alignment: .topLeading
            )
            .overlay(
                Button(action: {
                    showInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier())
                , alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showGameoverModal.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: - POPUP
            if $showGameoverModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0, content: {
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(.pink)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16, content: {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad Luck!, You lost all the coins. \n Let's Play Again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                showGameoverModal = false
                                coins = 100
                            }, label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            })
                        })
                        
                        Spacer()
                        
                    })
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    
                } //: End of ZStack
            }
        } //: End of ZStack
        .sheet(isPresented: $showInfoView, content: {
            InfoView()
        })
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
