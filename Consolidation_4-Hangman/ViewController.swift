import UIKit

class ViewController: UIViewController {
    
    var livesLeft: UILabel!
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
        livesLeft.text = "Lives: 0"
        view.addSubview(livesLeft)
        
        currentWord = UILabel()
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.textAlignment = .center
        currentWord.font = UIFont.systemFont(ofSize: 64)
        currentWord.text = "Current word"
        view.addSubview(currentWord)
        
        guessLetter = UITextField()
        guessLetter.translatesAutoresizingMaskIntoConstraints = false
        guessLetter.font = UIFont.systemFont(ofSize: 44)
        guessLetter.textAlignment = .center
        guessLetter.placeholder = "Tap to type in a letter."
        view.addSubview(guessLetter)
        
        clueForWord  = UILabel()
        clueForWord.translatesAutoresizingMaskIntoConstraints = false
        clueForWord.font = UIFont.systemFont(ofSize: 34)
        clueForWord.textAlignment = .center
        clueForWord.text = "A clue"
        view.addSubview(clueForWord)
        
        NSLayoutConstraint.activate ([
            livesLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            livesLeft.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            livesLeft.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.05, constant: 50),
            livesLeft.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30),
            
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
    
    var lives = 7 {
        didSet {
            livesLeft.text = "Lives: \(lives)"
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
                    
                    wordString += "\(word)\n"
                    clueString += "\(clue)\n"
                }
            }
        }
        
        clueForWord.text = clueString
        currentWord.text = wordString
    }
    
    func submitLetter(_ sender: UITextField) {
        
    }
    
}
