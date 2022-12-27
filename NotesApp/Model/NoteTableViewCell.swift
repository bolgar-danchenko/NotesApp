//
//  CustomNoteTableViewCell.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 27.12.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let id = "CustomNoteTableViewCell"
    
    // MARK: - Subviews
    
    private lazy var noteBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: Styles.customTitleFont, color: .black)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noteText: UILabel = {
        let label = UILabel()
        label.applyStyle(font: Styles.customTextFont, color: .darkGray)
        label.sizeToFit()
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: Styles.customDateFont, color: .darkGray)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupView() {
        contentView.clipsToBounds = true
        
        contentView.addSubview(noteBackground)
        noteBackground.addSubview(titleLabel)
        noteBackground.addSubview(noteText)
        noteBackground.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            noteBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            noteBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noteBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: noteBackground.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: noteBackground.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: noteBackground.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(equalToConstant: 60),
            
            noteText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            noteText.leadingAnchor.constraint(equalTo: noteBackground.leadingAnchor, constant: 16),
            noteText.trailingAnchor.constraint(equalTo: noteBackground.trailingAnchor, constant: -16),
            
        ])
    }
    
    // MARK: - Configure
    
    func configure(with model: Note) {
        
        titleLabel.text = model.title
        noteText.text = model.text
        
        let formatter = DateFormatter()
        if Date.isToday(day: model.date.get(.day)) {
            formatter.dateFormat = "HH:mm"
        } else if Date.isThisYear(year: model.date.get(.year)) {
            formatter.dateFormat = "MMM d"
        } else {
            formatter.dateFormat = "MM/dd/yyyy"
        }
        dateLabel.text = formatter.string(from: model.date)
        
        noteBackground.backgroundColor = UIColor(named: model.color)
    }
}
