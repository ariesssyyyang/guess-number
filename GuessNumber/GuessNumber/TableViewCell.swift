//
//  TableViewCell.swift
//  GuessNumber
//
//  Created by Aries Yang on 2022/9/28.
//

import UIKit

final class TableViewCell: UITableViewCell {

    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        label.textColor = .black
        label.font = .systemFont(ofSize: 12.0)

        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
        }
    }

    func config(_ text: String) {
        label.text = text
    }
}
