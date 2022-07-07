import UIKit

class ViewController: UIViewController {
    
    var livesLeft: UILabel!
    var wrongAnswers: UILabel!
    var currentWord: UILabel!
    var guessLetter: UITextField!
    var clueForWord: UILabel!

    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .systemRed
        
        livesLeft = UILabel()
        livesLeft.translatesAutoresizingMaskIntoConstraints = false
        livesLeft.layer.borderWidth = 2
        livesLeft.layer.borderColor = UIColor.white.cgColor
        livesLeft.font = UIFont.systemFont(ofSize: 24)
        livesLeft.textColor = .white
        livesLeft.textAlignment = .center
        livesLeft.text = "Lives: \(lives)"
        view.addSubview(livesLeft)
        
        wrongAnswers = UILabel()
        wrongAnswers.translatesAutoresizingMaskIntoConstraints = false
        wrongAnswers.layer.borderWidth = 2
        wrongAnswers.layer.borderColor = UIColor.white.cgColor
        wrongAnswers.font = UIFont.systemFont(ofSize: 24)
        wrongAnswers.textColor = .white
        wrongAnswers.textAlignment = .center
        wrongAnswers.text = "Mistakes: \(mistakes)"
        view.addSubview(wrongAnswers)
        
        currentWord = UILabel()
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.textAlignment = .center
        currentWord.font = UIFont.systemFont(ofSize: 64)
        currentWord.text = "Current word"
        view.addSubview(currentWord)
        
        /*guessLetter = UITextField()
        guessLetter.translatesAutoresizingMaskIntoConstraints = false
        guessLetter.font = UIFont.systemFont(ofSize: 44)
        guessLetter.textAlignment = .center
        guessLetter.placeholder = "Tap to type in a letter."
        guessLetter.isUserInteractionEnabled = false
        view.addSubview(guessLetter)*/
        
        let guessLetter = UIButton(type: .system)
        guessLetter.translatesAutoresizingMaskIntoConstraints = false
        guessLetter.setTitle("Tap to type in a letter", for: .normal)
        guessLetter.addTarget(self, action: #selector(promptForSubmition), for: .touchUpInside)
        view.addSubview(guessLetter)
        
        clueForWord  = UILabel()
        clueForWord.translatesAutoresizingMaskIntoConstraints = false
        clueForWord.font = UIFont.systemFont(ofSize: 24)
        clueForWord.textAlignment = .center
        clueForWord.text = "A clue"
        view.addSubview(clueForWord)
        
        NSLayoutConstraint.activate ([
            livesLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            livesLeft.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            livesLeft.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.05, constant: 50),
            livesLeft.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30),
            
            wrongAnswers.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            wrongAnswers.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            wrongAnswers.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.07, constant: 70),
            wrongAnswers.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30),
            
            currentWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWord.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            currentWord.bottomAnchor.constraint(equalTo: clueForWord.topAnchor),
            currentWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            currentWord.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            
            guessLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessLetter.topAnchor.constraint(equalTo: currentWord.bottomAnchor),
            guessLetter.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30),
            guessLetter.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            guessLetter.heightAnchor.constraint(equalToConstant: 40),
            
            clueForWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clueForWord.topAnchor.constraint(equalTo: currentWord.topAnchor, constant: 30),
            clueForWord.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 10),
            clueForWord.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            clueForWord.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30)
        ])
        
        loadGame()
    }
    
    var usedLetters = [Character]()
    var promptWord = [String]()
    var word = ""
    var guessedLetters = 0
    var lives = 7 {
        didSet {
            livesLeft.text = "Lives: \(lives)"
        }
    }
    var mistakes = 0 {
        didSet {
            wrongAnswers.text = "Mistakes: \(mistakes)"
        }
    }
    
    func loadGame() {
        
        var clueString = ""
        var wordString = ""
        
        if let gameFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let gameContent = try? String(contentsOf: gameFileURL) {
                var lines = gameContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let word = parts[0]
                    let clue = parts[1]
                    
                    for letter in word {
                        usedLetters.append(letter)
                        promptWord.append("_ ")
                    }
                    
                    wordString += "\(promptWord.joined())\n"
                    clueString += "\(clue)\n"
                }
            }
        }
        
        clueForWord.text = clueString
        currentWord.text = wordString
    }
    
    @objc func promptForSubmition() {
        let alertController = UIAlertController(title: "Please type in a letter.", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            guard let letter = alertController?.textFields?[0].text else { return }
            self?.submitLetter(letter)
        }
        alertController.addAction(submit)
        
        present(alertController, animated: true)
            
    }
    
    func submitLetter(_ letter: String) {
        
        let typedLetter = letter.uppercased()
        
        if typedLetter.count == 1 {
            if usedLetters.contains(Character(typedLetter)) {
                for (index, letter) in usedLetters.enumerated() {
                    if letter == Character(typedLetter) {
                        promptWord[index] = typedLetter
                        guessedLetters += 1
                        
                        if guessedLetters == word.count {
                            let victoryAlertController = UIAlertController(title: "Well done!", message: "You avoided the gallows!", preferredStyle: .alert)
                            victoryAlertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadNextLevel))
                            present(victoryAlertController, animated: true)
                        }
                    }
                }
            } else if !usedLetters.contains(Character(typedLetter)) {
                
                lives -= 1
                mistakes += 1
                
                if lives >= 1 {
                    let mistakeAlertController = UIAlertController(title: "Sorry, no!", message: "Please pick another letter!", preferredStyle: .alert)
                    mistakeAlertController.addAction(UIAlertAction(title: "Damn...", style: .default))
                    present(mistakeAlertController, animated: true)
                }
                if lives == 0 {
                    let gameOverAlertController = UIAlertController(title: "Game over!", message: "If you believe in nirvana, you should try again!", preferredStyle: .alert)
                    gameOverAlertController.addAction(UIAlertAction(title: "Resurrect me!", style: .default))
                    present(gameOverAlertController, animated: true)
            }
        }
    } else if typedLetter.count > 1 {
        let tooManyLettersAlertController = UIAlertController(title: "Too many letters!", message: "You are supposed to type one.", preferredStyle: .alert)
        tooManyLettersAlertController.addAction(UIAlertAction(title: "I'm sorry!", style: .default))
        present(tooManyLettersAlertController, animated: true)
    }
    
    /* func submitLetter(_ letter: String) {
        
        guard let typedLetter = guessLetter.text?.uppercased() else { return }
        
        if typedLetter.count == 1 {
            if usedLetters.contains(Character(typedLetter)) {
                for (index, letter) in usedLetters.enumerated() {
                    if letter == Character(typedLetter) {
                        promptWord[index] = typedLetter
                        guessedLetters += 1
                        guessLetter.text = "_"
                        if guessedLetters == word.count {
                            let victoryAlertController = UIAlertController(title: "Well done!", message: "You avoided the gallows!", preferredStyle: .alert)
                            victoryAlertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadNextLevel))
                            present(victoryAlertController, animated: true)
                        }
                    }
                }
            } else if !usedLetters.contains(Character(typedLetter)) {
                if lives >= 1 {
                    let mistakeAlertController = UIAlertController(title: "Sorry, no!", message: "Please pick another letter!", preferredStyle: .alert)
                    mistakeAlertController.addAction(UIAlertAction(title: "Damn...", style: .default))
                    present(mistakeAlertController, animated: true)
                }
                if lives == 0 {
                    let gameOverAlertController = UIAlertController(title: "Game over!", message: "If you believe in nirvana, you should try again!", preferredStyle: .alert)
                    gameOverAlertController.addAction(UIAlertAction(title: "Resurrect me!", style: .default))
                    present(gameOverAlertController, animated: true)
            }
        } else if typedLetter.count > 1 {
            let tooManyLettersAlertController = UIAlertController(title: "Too many letters!", message: "You are supposed to type one.", preferredStyle: .alert)
            tooManyLettersAlertController.addAction(UIAlertAction(title: "I'm sorry!", style: .default))
            present(tooManyLettersAlertController, animated: true)
        }
    } */
        func reloadGame() {
            
        }
        
        func loadNextLevel(action: UIAlertAction! = nil) {
            
        }
    }
}
