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
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
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
        playSound(sound: "win", type: "mp3")
        coins += betAmount * 10
    }

    func newHighScore() {
        playSound(sound: "high-score", type: "mp3")
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "userHighScore")
    }
    
    func playerLoses() {
        coins -= betAmount
    }

    func bet20() {
        betAmount = 20
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func bet10() {
        betAmount = 10
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func gameover() {
        if coins <= 0 {
            //SHOW MODAL
            showGameoverModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func reset() {
        highScore = 0
        coins = 100
        bet10()
        UserDefaults.standard.set(0, forKey: "userHighScore")
        playSound(sound: "chimeup", type: "mp3")
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
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...1.2)), value: animatingSymbol)
                            .onAppear(perform: {
                                animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        
                        //MARK: - REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...1.2)), value: animatingSymbol)
                                .onAppear(perform: {
                                    animatingSymbol.toggle()
                                })
                        }
                        
                        Spacer()

                        //MARK: - REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.2)), value: animatingSymbol)
                                .onAppear(perform: {
                                    animatingSymbol.toggle()
                                })
                        }
                    })
                    .frame(maxWidth: 500)
                    
                    //MARK: - SPIN BUTTON
                    Button(action: {
                    
                        playSound(sound: "spin", type: "mp3")
                        withAnimation {
                            animatingSymbol = false
                        }
                        spins()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation() {
                                animatingSymbol = true
                            }
                        }
                       
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
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipModifier())
                        
                        Spacer()
                        
                        //MARK: - BET 20
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
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
            
            //MARK: - POPUP MODAL
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
                                animatingModal = false
                                bet10()
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
                        
                    }) //: End of VStack
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1), value: animatingModal)
                    .onAppear(perform: {
                        animatingModal = true
                    })
                    
                } //: End of ZStack
            }  //: End of IF
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
