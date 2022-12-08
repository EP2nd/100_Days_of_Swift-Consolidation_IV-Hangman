//
//  ViewController.swift
//  Consolidation_4-Hangman
//
//  Created by Edwin Przeźwiecki Jr. on 06/06/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var livesLabel: UILabel!
    var currentWord: UILabel!
    var clueForWord: UILabel!
    
    var guessLetter: UITextField!

    override func viewDidLoad() {
        
        view = UIView()
        
        view.backgroundColor = .systemRed
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.layer.borderWidth = 2
        livesLabel.layer.borderColor = UIColor.white.cgColor
        livesLabel.font = UIFont.systemFont(ofSize: 24)
        livesLabel.textColor = .white
        livesLabel.textAlignment = .center
        livesLabel.text = "Lives: \(lives)/7"
        view.addSubview(livesLabel)
        
        clueForWord  = UILabel()
        clueForWord.translatesAutoresizingMaskIntoConstraints = false
        clueForWord.font = UIFont.systemFont(ofSize: 24)
        clueForWord.textAlignment = .center
        clueForWord.text = "A clue"
        view.addSubview(clueForWord)
        
        currentWord = UILabel()
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.textAlignment = .center
        currentWord.font = UIFont.systemFont(ofSize: 64)
        currentWord.text = "Current word"
        view.addSubview(currentWord)
        
        let guessLetter = UIButton(type: .custom)
        guessLetter.translatesAutoresizingMaskIntoConstraints = false
        guessLetter.setTitle("Tap to type in a letter", for: .normal)
        guessLetter.addTarget(self, action: #selector(promptForSubmition), for: .touchUpInside)
        view.addSubview(guessLetter)
        
        NSLayoutConstraint.activate ([
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -50),
            livesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.06, constant: 60),
            livesLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30),
            
            clueForWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clueForWord.topAnchor.constraint(equalTo: livesLabel.bottomAnchor),
            
            currentWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWord.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: 25),
            currentWord.topAnchor.constraint(equalTo: clueForWord.bottomAnchor, constant: 20),
            
            guessLetter.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            guessLetter.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: 250),
        ])
        
        performSelector(inBackground: #selector(loadGame), with: nil)
    }

    var usedLetters = [Character]()
    var promptWord = [String]()
    
    var answer = ""
    
    var guessedLetters = 0
    var lives = 7 {
        didSet {
            livesLabel.text = "Lives: \(lives)/7"
        }
    }
    var score = 0
    
    @objc func loadGame() {
        
        var clueString = ""
        var wordString = ""
        
        if let gameFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let gameContent = try? String(contentsOf: gameFileURL) {
                
                var lines = gameContent.components(separatedBy: "\n")
                lines.shuffle()
                
                let play = lines.randomElement()!
                let parts = play.components(separatedBy: ": ")
                
                let keyword = parts[0]
                let clue = parts[1]
                
                answer = keyword
                
                for letter in answer {
                    usedLetters.append(letter)
                    promptWord.append("_ ")
                }
                wordString += "\(promptWord.joined())"
                clueString += "\(clue)"
            }
        }
        DispatchQueue.main.async {
            self.clueForWord.text = clueString
            self.currentWord.text = wordString
        }
    }

    func submitLetter(_ letter: String) {
        
        let typedLetter = letter.uppercased()
        
        if typedLetter.count == 1 {
            if usedLetters.contains(Character(typedLetter)) {
                for (index, letter) in usedLetters.enumerated() {
                    if letter == Character(typedLetter) {
                        
                        promptWord[index] = typedLetter
                        
                        currentWord.text = promptWord.joined().uppercased()
                        
                        guessedLetters += 1
                        score += 1
                        
                        if score == answer.count {
                            let victoryAlertController = UIAlertController(title: "Well done!", message: "You avoided the gallows!", preferredStyle: .alert)
                            victoryAlertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadNextWord))
                            
                            present(victoryAlertController, animated: true)
                        }
                    }
                }
            } else if !usedLetters.contains(Character(typedLetter)) {
                
                lives -= 1
                
                if lives > 1 {
                    let mistakeAlertController = UIAlertController(title: "Sorry, no!", message: "Please pick another letter.", preferredStyle: .alert)
                    mistakeAlertController.addAction(UIAlertAction(title: "Damn...", style: .default))
                    
                    present(mistakeAlertController, animated: true)
                }
                if lives < 1 {
                    let gameOverAlertController = UIAlertController(title: "Game over!", message: "If you believe in nirvana, you should try again!", preferredStyle: .alert)
                    gameOverAlertController.addAction(UIAlertAction(title: "Resurrect me, please!", style: .default))
                    
                    present(gameOverAlertController, animated: true)
                }
            }
        } else if typedLetter.count > 1 {
            let tooManyLettersAlertController = UIAlertController(title: "Too many letters!", message: "You are supposed to pick one.", preferredStyle: .alert)
            tooManyLettersAlertController.addAction(UIAlertAction(title: "I'm sorry!", style: .default))
            
            present(tooManyLettersAlertController, animated: true)
        } else if typedLetter.count == 0 {
            let noLettersAlertController = UIAlertController(title: "No letter selected!", message: "Was that a mistap?", preferredStyle: .alert)
            noLettersAlertController.addAction(UIAlertAction(title: "Oops!", style: .default))
            
            present(noLettersAlertController, animated: true)
        }
    }
    
    func reloadGame() {
        performSelector(inBackground: #selector(loadGame), with: nil)
    }
    
    func loadNextWord(action: UIAlertAction! = nil) {
        answer = ""
        promptWord.removeAll()
        usedLetters.removeAll()
        lives = 7
        
        performSelector(inBackground: #selector(loadGame), with: nil)
    }
    
    @objc func promptForSubmition() {
        let alertController = UIAlertController(title: "Please type in a letter.", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            
            guard let letter = alertController?.textFields?[0].text else { return }
            
            self?.submitLetter(letter)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(submit)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}
