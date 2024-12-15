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
    private let openAIKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    private var typedText: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.displayLabel.text = self.typedText
                self.processText(self.typedText) { processedText in
                    DispatchQueue.main.async {
                        self.displayLabel.text = processedText
                    }
                }
            }
        }
    }
    private var keys: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["space"]
        // ["123", "next", "space", "return"]
    ]
    
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
        keyboardView.backgroundColor = .systemGray6
        view.addSubview(keyboardView)
        
        displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.backgroundColor = .white
        displayLabel.textAlignment = .left
        displayLabel.font = .systemFont(ofSize: 16)
        displayLabel.text = typedText
        displayLabel.layer.cornerRadius = 5
        displayLabel.layer.masksToBounds = true
        displayLabel.isUserInteractionEnabled = true
        keyboardView.addSubview(displayLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayLabelTapped))
        displayLabel.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
            keyboardView.rightAnchor.constraint(equalTo: view.rightAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            displayLabel.topAnchor.constraint(equalTo: keyboardView.topAnchor, constant: 5),
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
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 5
        let sideInset: CGFloat = 3
        
        // Calculate keyboard height
        let keyboardHeight: CGFloat = CGFloat(keys.count) * (buttonHeight + buttonSpacing) + 40 // Extra height for display label
        
        // Set keyboard height constraint
        NSLayoutConstraint.activate([
            keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight)
        ])
        
        for (rowIndex, row) in keys.enumerated() {
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            rowView.backgroundColor = .systemGray6 // Debug color
            keyboardView.addSubview(rowView)
            
            NSLayoutConstraint.activate([
                rowView.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: sideInset),
                rowView.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -sideInset),
                rowView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: CGFloat(rowIndex) * (buttonHeight + buttonSpacing) + 5),
                rowView.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
            
            // Calculate total width units for the row
            let totalUnits = row.reduce(0) { total, key in
                switch key {
                case "space": return total + 4
                case "return", "123", "next": return total + 2
                default: return total + 1
                }
            }
            
            // Keep track of used width
            var currentX: CGFloat = 0
            let availableWidth = UIScreen.main.bounds.width - (2 * sideInset)
            let unitWidth = (availableWidth - (CGFloat(row.count - 1) * buttonSpacing)) / CGFloat(totalUnits)
            
            for key in row {
                let button = createButton(withTitle: key)
                rowView.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                // Calculate button width
                let units = {
                    switch key {
                    case "space": return 4
                    case "return", "123", "next": return 2
                    default: return 1
                    }
                }()
                
                let buttonWidth = unitWidth * CGFloat(units)
                
                NSLayoutConstraint.activate([
                    button.leftAnchor.constraint(equalTo: rowView.leftAnchor, constant: currentX),
                    button.topAnchor.constraint(equalTo: rowView.topAnchor),
                    button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
                    button.widthAnchor.constraint(equalToConstant: buttonWidth)
                ])
                
                currentX += buttonWidth + buttonSpacing
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
            // Handle shift (not implemented)
            break
        default:
            typedText += key
        }
    }
    
    @objc private func displayLabelTapped() {
        guard !typedText.isEmpty else { return }
        textDocumentProxy.insertText(displayLabel.text ?? "")
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
