//
//  RecieveMatchView.swift
//  UQuiz
//
//  Created by Greed on 4/8/24.
//

import UIKit
import SnapKit

class ReceiveMatchView: BaseView {
    var numberText: String = "    "
    var isDisable: Bool = true

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 30, weight: .bold)
        label.text = "퀴즈 받기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 24, weight: .bold)
        label.text = "공유 받은 코드를 입력해주세요."
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .pretendard(size: 40, weight: .bold)
        textField.text = numberText
        textField.textColor = .pointOrange
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var numberPadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(textField)
        addSubview(numberPadView)
    }

    private func setupViews() {
        backgroundColor = .white

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 240),
            textField.heightAnchor.constraint(equalToConstant: 60),

            numberPadView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            numberPadView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberPadView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            numberPadView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        let rows = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "Del"]
        ]

        for (i, row) in rows.enumerated() {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually
            numberPadView.addSubview(rowStackView)

            for (j, number) in row.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(number, for: .normal)
                button.titleLabel?.font = .pretendard(size: 30, weight: .bold)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
                button.tag = i * 3 + j + 1
                rowStackView.addArrangedSubview(button)
            }

            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rowStackView.topAnchor.constraint(equalTo: numberPadView.topAnchor, constant: CGFloat(i) * 72),
                rowStackView.leadingAnchor.constraint(equalTo: numberPadView.leadingAnchor),
                rowStackView.trailingAnchor.constraint(equalTo: numberPadView.trailingAnchor),
                rowStackView.heightAnchor.constraint(equalToConstant: 72)
            ])
        }
    }

    @objc func handleButtonTap(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }

        if number == "Del" {
            if !numberText.isEmpty {
                if let index = findLastNumberIndex(in: numberText) {
                    var arr = Array(numberText)
                    let ind = abs(index - 3)
                    arr[ind] = " "
                    numberText = String(arr)
                }
            }
        } else if numberText.count <= 4 {
            let originalString = numberText
            let targetString = " "
            let replacementString = number

            if let range = originalString.range(of: targetString) {
                let replacedString = originalString.replacingOccurrences(of: targetString, with: replacementString, options: .literal, range: range)
                numberText = replacedString
            }
        }

        textField.text = numberText

    }

    func findLastNumberIndex(in text: String) -> Int? {
        let reversedText = String(text.reversed())
        if let index = reversedText.firstIndex(where: { $0.isNumber }) {
            return reversedText.distance(from: reversedText.startIndex, to: index)
        }
        return nil
    }

}
