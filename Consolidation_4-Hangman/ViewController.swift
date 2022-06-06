import UIKit

class ViewController: UIViewController {
    
    var livesLeft: UILabel!
    var currentWord: UILabel!
    var guessLetter: UITextField!
    var wordsList = [String]()

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
        guessLetter.font = UIFont.systemFont(ofSize: 32)
        guessLetter.textAlignment = .center
        guessLetter.placeholder = "Tap to type in a letter."
        view.addSubview(guessLetter)
        
        NSLayoutConstraint.activate ([
            livesLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            livesLeft.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            livesLeft.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.05, constant: 50),
            livesLeft.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.03, constant: 30),
            
            currentWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWord.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            currentWord.bottomAnchor.constraint(equalTo: guessLetter.topAnchor),
            currentWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            currentWord.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            
            guessLetter.topAnchor.constraint(equalTo: currentWord.bottomAnchor),
            guessLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessLetter.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
