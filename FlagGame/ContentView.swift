//
//  ContentView.swift
//  FlagGame
//
//  Created by Насрулло Исмоилжонов on 18/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var roundEnd = false
    @State private var roundCounter = 0
    
    @State private var besideCorrect = false
    @State private var besideWrong = false
    @State private var selectedNumber = 0
    @State private var animateOpacity = 1.0
    @State private var colorProp = false
    @State private var showBack = false
    struct FlagImage: View {
        var image: String
        
        var body: some View {
            Image(image)
                .clipShape(.capsule)
                .shadow(radius: 5)
                
        }
    }
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.9, green: 0.9, blue: 0.45), location: 0.3),
//                .init(color: Color(red: 0.01, green: 0.01, blue: 0.01), location: 0.6),
//                .init(color: Color(red: 0.5, green: 0.5, blue: 0.5), location: 0.9)
//            ],center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary.opacity(0.99))
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.title.weight(.semibold))
                        
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            withAnimation(.spring(duration: 1, bounce: 0.6)){
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknown"])
//                        .rotation3DEffect(.degrees(number == correctAnswer ? rotatingAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .shadow(color: (colorProp ? .green : .red), radius: (showBack ? 10 : 0), x: 0, y: 0)
                        .rotation3DEffect(.degrees(besideCorrect && correctAnswer == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(number != correctAnswer && besideCorrect ? animateOpacity : 1)
                        .scaleEffect(number != correctAnswer && besideCorrect ? 0.8 : 1)
                        
                        .rotation3DEffect(.degrees(besideWrong && selectedNumber == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(besideWrong && selectedNumber != number ? animateOpacity : 1)
                        .scaleEffect(besideWrong && selectedNumber != number ? 0.8 : 1)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial.opacity(0.6))
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(totalScore)")
        }
        
        
        .alert("That's the end of this game", isPresented: $roundEnd) {
            Button("Restart", action: restart)
        } message: {
            Text("Your score is \(totalScore) out of 8")
        }
    }
    
    func flagTapped(_ number: Int) {
        if roundCounter < 7 {
            selectedNumber = number
            if number == correctAnswer {
                withAnimation{
                    scoreTitle = "Correct"
                    totalScore += 1
                    besideCorrect = true
                    animateOpacity = 0.25
                    colorProp = true
                }
                
            } else {
                withAnimation{
                    scoreTitle = "Wrong. That's the flag of \(countries[number])"
                    animateOpacity = 0.25
                    besideWrong = true
                    colorProp = false
                }
                
            }
            roundCounter += 1
            showBack = true
        }else{
            roundEnd = true
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            showingScore = true
        }
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        besideCorrect = false
        besideWrong = false
        colorProp = false
        showBack = false
    }
    func restart(){
        roundCounter = 0
        totalScore = 0
    }
}

#Preview {
    ContentView()
}
