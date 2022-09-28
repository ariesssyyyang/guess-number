//
//  ViewController.swift
//  GuessNumber
//
//  Created by Aries Yang on 2022/9/28.
//

import UIKit

class ViewController: UIViewController {

    struct Input {
        let index: Int
        let value: Int
    }

    // MARK: - Views

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter your answer..."
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.keyboardType = .numberPad
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let tableView: UITableView = UITableView()

    // MARK: - Properties

    // 1...9, no repeat
    private var numberPool: [Int] = []

    // [value: index]
    private var answer: [Int: Int] = [:]

    private var roundCounter: Int = 0

    private var logs: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        restart()
    }

    // MARK: - Setup

    private func setupViews() {
        sendButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        sendButton.snp.makeConstraints {
            $0.height.equalTo(30.0)
        }

        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self

        let hstackView = UIStackView(arrangedSubviews: [textField, sendButton])
        hstackView.spacing = 8.0
        hstackView.isLayoutMarginsRelativeArrangement = true
        hstackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)

        let vStackView = UIStackView(arrangedSubviews: [hstackView, tableView])
        vStackView.axis = .vertical
        vStackView.spacing = 24.0

        view.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)//.inset(20)
        }

        let restartButton = UIButton()
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(.black, for: .normal)
        restartButton.backgroundColor = .orange
        restartButton.layer.cornerRadius = 4.0
        restartButton.clipsToBounds = true
        restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)

        view.addSubview(restartButton)
        restartButton.snp.makeConstraints {
            $0.height.equalTo(50.0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }


    // MARK: - Helper

    private func isValidInput(_ text: String) -> Bool {
        guard
            !text.contains("0"),
            text.count == 4,
            text.count == Set(text).count
        else { return false }

        return true
    }

    @objc
    private func checkAnswer() {
        guard
            let inputText = textField.text,
            let inputNumber = Int(inputText),
            isValidInput(inputText)
        else {
            return logs.append("⚠️ WARNING: Parameter error, input is invalid")
        }

        let first = Input(index: 0, value: inputNumber / 1000)
        let second = Input(index: 1, value: (inputNumber % 1000) / 100)
        let third = Input(index: 2, value: (inputNumber % 100) / 10)
        let four = Input(index: 3, value: inputNumber % 10)

        var counterA = 0
        var counterB = 0

        roundCounter += 1

        [first, second, third, four].forEach { element in
            if let index = answer[element.value] {
                if element.index == index {
                    counterA += 1
                } else {
                    counterB += 1
                }
            }
        }

        let resultWord: String
        if counterA == 4 {
            resultWord = "🎉 CORRECT"
        } else {
            resultWord = "❌ WRONG"
        }
        logs.append("\(resultWord): \(roundCounter) time(s) enter \(inputText). Result: \(counterA)A \(counterB)B")
    }

    @objc
    private func restart() {
        textField.text = nil
        numberPool = Array(1...9).shuffled()

        answer = [:]
        let first = numberPool.removeFirst()
        let second = numberPool.removeFirst()
        let third = numberPool.removeFirst()
        let four = numberPool.removeFirst()
        answer[first] = 0
        answer[second] = 1
        answer[third] = 2
        answer[four] = 3

        roundCounter = 0
        logs = []

        print("🚀 answer >> ", first, second, third, four)
    }

    @objc
    private func hideKeyboard() {
        textField.resignFirstResponder()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)

        if let tableViewCell = cell as? TableViewCell {
            tableViewCell.config(logs[indexPath.row])
        }

        return cell
    }
}
