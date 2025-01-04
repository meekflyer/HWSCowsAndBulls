//
//  ContentView.swift
//  HWSCowsAndBulls
//
//  Created by Jonathan on 1/4/25.
//

import SwiftUI



struct ContentView: View {
    
    @State private var guess=""
    @State private var guesses = [String]()
    @State private var answer = ""
    @State private var isGameOver = false
    
    let answerLength = 4
    
        
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter a guess...", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action: submitGuess)
            }
            .padding()
            
            List(guesses, id: \.self) { guess in
                HStack {
                    Text(guess)
                    Spacer() // take up all free space
                    Text(result(for: guess))
                }
            }
            .listStyle(.sidebar)
        }
        .navigationTitle("Cows and Bulls")
        .frame(width: 250)
        .frame(minHeight: 300)
        .onAppear(perform: startNewGame)
        .alert("You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            Text("Congratulations! Click OK to play again.")
        }
    }
    
    func submitGuess() {
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }

        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }

        guesses.insert(guess, at: 0)

        if result(for: guess).contains("\(answerLength)b") {
            isGameOver = true
        }

        // clear their guess string
        guess = ""
    }


    
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }

    func startNewGame() {
        guess = ""
        guesses.removeAll()
        answer = ""
        
        let numbers = (0...9).shuffled()
        
        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
    }
}

#Preview {
    ContentView()
}


