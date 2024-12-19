//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by zhe on 12/13/24.
//

import UIKit
import os.log

class KeyboardViewController: UIInputViewController {
    
    private let logger = OSLog(subsystem: "com.z.emoji-keyboard.keyboard", category: "keyboard")
    @IBOutlet var nextKeyboardButton: UIButton!
    private var keyboardView: UIView!
    private var displayLabel: UILabel!
    private var emojiLabel: UILabel!
    private let openAIKey = ""
    private var typedText: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.displayLabel.text = self.typedText
                self.processText(self.typedText) { processedText in
                    DispatchQueue.main.async {
                        self.emojiLabel.text = processedText
                    }
                }
            }
        }
    }
    private var keys: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
        ["space"]
        // ["123", "next", "space", "return"]
    ]
    private var isShiftEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        setupNextKeyboardButton()
        createKeys()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        super.textWillChange(textInput)
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
    }
    
    private func setupKeyboardView() {
        keyboardView = UIView(frame: .zero)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.backgroundColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)  // iOS keyboard background color
        view.addSubview(keyboardView)
        
        emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.backgroundColor = .clear
        emojiLabel.textAlignment = .left
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textColor = .black
        emojiLabel.text = ""
        emojiLabel.isUserInteractionEnabled = true
        keyboardView.addSubview(emojiLabel)
        
        displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.backgroundColor = .clear
        displayLabel.textAlignment = .left
        displayLabel.font = .systemFont(ofSize: 16)
        displayLabel.textColor = .black
        displayLabel.text = typedText
        displayLabel.isUserInteractionEnabled = true
        keyboardView.addSubview(displayLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayLabelTapped))
        displayLabel.addGestureRecognizer(tapGesture)
        
        let emojiTapGesture = UITapGestureRecognizer(target: self, action: #selector(emojiLabelTapped))
        emojiLabel.addGestureRecognizer(emojiTapGesture)
        
        NSLayoutConstraint.activate([
            keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
            keyboardView.rightAnchor.constraint(equalTo: view.rightAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: keyboardView.topAnchor, constant: 5),
            emojiLabel.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 10),
            emojiLabel.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -10),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),
            
            displayLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 5),
            displayLabel.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 10),
            displayLabel.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -10),
            displayLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .allTouchEvents)
    }
    
    private func createKeys() {
        let buttonHeight: CGFloat = 30
        let buttonSpacing: CGFloat = 3
        let sideInset: CGFloat = 3
        
        // Calculate total keyboard height needed
        let totalRows = CGFloat(keys.count)
        let totalSpacing = (totalRows - 1) * buttonSpacing
        let labelsHeight: CGFloat = 70
        let keyboardHeight = (buttonHeight * totalRows) + totalSpacing + labelsHeight
        
        keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
        
        for (rowIndex, row) in keys.enumerated() {
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            rowView.backgroundColor = .clear
            keyboardView.addSubview(rowView)
            
            NSLayoutConstraint.activate([
                rowView.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: sideInset),
                rowView.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -sideInset),
                rowView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: CGFloat(rowIndex) * (buttonHeight + buttonSpacing) + 2),
                rowView.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
            
            let buttonWidth = (UIScreen.main.bounds.width - (CGFloat(row.count + 1) * buttonSpacing)) / CGFloat(row.count)
            
            for (columnIndex, key) in row.enumerated() {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                // Set button appearance based on key type
                if key == "space" {
                    button.setTitle("space", for: .normal)
                    button.backgroundColor = .white
                } else if key == "⌫" {
                    button.setTitle("⌫", for: .normal)
                    button.backgroundColor = UIColor(red: 172/255, green: 179/255, blue: 188/255, alpha: 1.0)  // Delete key color
                    button.titleLabel?.font = .systemFont(ofSize: 20)  // Larger font for the delete symbol
                } else if key == "⇧" {
                    button.setTitle("⇧", for: .normal)
                    button.backgroundColor = UIColor(red: 172/255, green: 179/255, blue: 188/255, alpha: 1.0)
                    if isShiftEnabled {
                        button.backgroundColor = .white
                    }
                } else {
                    let displayKey = isShiftEnabled ? key.uppercased() : key
                    button.setTitle(displayKey, for: .normal)
                    button.backgroundColor = .white
                }
                
                // Common button styling
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 15)
                button.layer.cornerRadius = 5
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOffset = CGSize(width: 0, height: 1)
                button.layer.shadowOpacity = 0.2
                button.layer.shadowRadius = 0
                
                rowView.addSubview(button)
                
                let buttonConstraints: [NSLayoutConstraint]
                if key == "space" {
                    // Make space bar wider
                    buttonConstraints = [
                        button.leftAnchor.constraint(equalTo: rowView.leftAnchor, constant: buttonWidth * 0.2),
                        button.rightAnchor.constraint(equalTo: rowView.rightAnchor, constant: -buttonWidth * 0.2),
                        button.topAnchor.constraint(equalTo: rowView.topAnchor),
                        button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
                    ]
                } else {
                    buttonConstraints = [
                        button.leftAnchor.constraint(equalTo: rowView.leftAnchor, constant: CGFloat(columnIndex) * (buttonWidth + buttonSpacing)),
                        button.widthAnchor.constraint(equalToConstant: buttonWidth),
                        button.topAnchor.constraint(equalTo: rowView.topAnchor),
                        button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
                    ]
                }
                NSLayoutConstraint.activate(buttonConstraints)
                
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
            }
        }
    }
    
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        return button
    }
    
    @objc private func keyPressed(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }
        
        switch key {
        case "⌫":
            if !typedText.isEmpty {
                typedText.removeLast()
            }
        case "space":
            typedText += " "
        case "return":
            textDocumentProxy.insertText("\n")
        case "next":
            advanceToNextInputMode()
        case "123":
            // Handle number pad (not implemented)
            break
        case "⇧":
            isShiftEnabled.toggle()
            // Refresh all letter keys
            for view in keyboardView.subviews {
                if let rowView = view as? UIView {
                    for case let button as UIButton in rowView.subviews {
                        if let title = button.title(for: .normal),
                           title != "⌫" && title != "space" && title != "⇧" {
                            button.setTitle(isShiftEnabled ? title.uppercased() : title.lowercased(), for: .normal)
                        }
                        if button.title(for: .normal) == "⇧" {
                            button.backgroundColor = isShiftEnabled ? .white : UIColor(red: 172/255, green: 179/255, blue: 188/255, alpha: 1.0)
                        }
                    }
                }
            }
        default:
            typedText += key
        }
    }
    
    @objc private func displayLabelTapped() {
        guard !typedText.isEmpty else { return }
        textDocumentProxy.insertText(displayLabel.text ?? "")
        typedText = ""
    }
    
    @objc private func emojiLabelTapped() {
        guard let emojiText = emojiLabel.text, !emojiText.isEmpty else { return }
        textDocumentProxy.insertText(emojiText)
        typedText = ""
    }
    
    private func processText(_ text: String, completion: @escaping (String) -> Void) {
        guard !text.isEmpty else {
            completion("")
            return
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: [
                Message(role: "system", content: "You are a helpful assistant that converts text to emojis. Only respond with emojis, no text."),
                Message(role: "user", content: text)
            ],
            temperature: 0.7
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            os_log(.error, log: logger, "Failed to encode request: %{public}@", error.localizedDescription)
            completion(text)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                os_log(.error, log: self.logger, "Network error: %{public}@", error.localizedDescription)
                completion(text)
                return
            }
            
            guard let data = data else {
                os_log(.error, log: self.logger, "No data received")
                completion(text)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                let emojiText = response.choices.first?.message.content ?? text
                completion(emojiText)
            } catch {
                os_log(.error, log: self.logger, "Failed to decode response: %{public}@", error.localizedDescription)
                completion(text)
            }
        }
        
        task.resume()
    }
}

// MARK: - OpenAI API Models
struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
}

struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finish_reason: String
}

struct Usage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}
