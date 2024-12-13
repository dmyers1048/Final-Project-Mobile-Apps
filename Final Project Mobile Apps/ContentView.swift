//
//  ContentView.swift
//  Final Project Mobile Apps
//
//  Created by Devan Myers on 11/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var playerChoice: String = "❔"
    @State private var computerChoice: String = "❔"
    @State private var resultMessage: String = "Choose your move!"
    @State private var showResult: Bool = false
    @State private var isPlayingAgainstComputer: Bool = true
    @State private var friendChoice: String = "❔"
    @State private var bothPlayersReady: Bool = false
    //an array that holds each emoji
    let choices = ["✊", "✋", "✌️"]

    var body: some View {
        VStack(spacing: 40) {
            Text("Rock Paper Scissors")
                .font(.largeTitle)
                .bold()
            //decide player vs computer
            Picker("Game Mode", selection: $isPlayingAgainstComputer) {
                Text("Computer").tag(true)
                Text("Friend").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            //pretty ui for the players emojis
            HStack {
                VStack {
                    Text("You")
                        .font(.title2)
                        .bold()
                    Text(bothPlayersReady || isPlayingAgainstComputer ? playerChoice : "❔")
                        .font(.system(size: 100))
                    //animation for users emojis
                        .rotationEffect(.degrees((bothPlayersReady || isPlayingAgainstComputer ? playerChoice : "❔") == "❔" ? 0 : 360))
                        .animation(.easeInOut(duration: 0.5), value: bothPlayersReady || isPlayingAgainstComputer ? playerChoice : "❔")
                }
                Spacer()
                VStack {
                    //decide what status to display for opponent
                    Text(isPlayingAgainstComputer ? "Computer" : "Friend")
                        .font(.title2)
                        .bold()
                    //decide what emoji to display
                    Text(bothPlayersReady ? (isPlayingAgainstComputer ? computerChoice : friendChoice) : "❔")
                        .font(.system(size: 100))
                    
                    //animation for opponent emojis
                        .rotationEffect(.degrees((bothPlayersReady ? (isPlayingAgainstComputer ? computerChoice : friendChoice) : "❔") == "❔" ? 0 : 360))
                        .animation(.easeInOut(duration: 0.5), value: bothPlayersReady ? (isPlayingAgainstComputer ? computerChoice : friendChoice) : "❔")
                }
            }
            .padding(.horizontal)
            Text(resultMessage)
                .font(.title2)
                .foregroundColor(.secondary)
            HStack(spacing: 20) {
                //id: \..self tells swift to use each emoji as an identifier
                //makes button for move choices
                ForEach(choices, id: \..self) { choice in
                    Button(action: {
                        if isPlayingAgainstComputer {
                            playGameAgainstComputer(playerMove: choice)
                        } else {
                            if playerChoice == "❔" {
                                playerChoice = choice
                                resultMessage = "Waiting for friend to choose..."
                            } else {
                                friendChoice = choice
                                bothPlayersReady = true
                                determineWinner()
                            }
                        }
                    }) {
                        Text(choice)
                            .font(.system(size: 80))
                            .padding()
                            .background(Color.blue.opacity(0.7))
                        
                            //changes selection of move from unshaped square to circle
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .alert(isPresented: $showResult) {
            Alert(title: Text("Game Over"), message: Text(resultMessage), dismissButton: .default(Text("Play Again"), action: resetGame))
        }
    }
    //randomizes computers choice and calls determineWinner function
    private func playGameAgainstComputer(playerMove: String) {
        playerChoice = playerMove
        computerChoice = choices.randomElement()!
        bothPlayersReady = true
        determineWinner()
    }
    //uses rules of rock paper scissors to determine winner
    private func determineWinner() {
        let opponentChoice = isPlayingAgainstComputer ? computerChoice : friendChoice
        // determine the result
        if playerChoice == opponentChoice {
            resultMessage = "It's a draw!"
        } else if (playerChoice == "✊" && opponentChoice == "✌️") ||
                    (playerChoice == "✋" && opponentChoice == "✊") ||
                    (playerChoice == "✌️" && opponentChoice == "✋") {
            resultMessage = "You Win!"
        } else {
            resultMessage = "You Lose!"
        }
        // show the result of game after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showResult = true
        }
    }
    //sets each string back to a blank choice and makes players choose moves again
    private func resetGame() {
        playerChoice = "❔"
        computerChoice = "❔"
        friendChoice = "❔"
        bothPlayersReady = false
        resultMessage = "Choose your move!"
    }
}

#Preview {
    ContentView()
}
