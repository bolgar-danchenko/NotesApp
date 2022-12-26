//
//  NoteTableViewCell.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let id = "NoteTableViewCell"
    private var note: Note?
    var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        textLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        detailTextLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupDateLabel() {
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 74, height: 50))
        dateLabel.textAlignment = .right
        accessoryView = dateLabel
        
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 14)
    }
    
    func configureLabels() {
        self.textLabel?.text = note?.title ?? ""
        self.detailTextLabel?.text = note?.text ?? ""
        
        guard let note = note else {
            print("Found nil value in variable notes")
            return
        }
        let formatter = DateFormatter()
        if Date.isToday(day: note.date.get(.day)) {
            formatter.dateFormat = "HH:mm"
        } else if Date.isThisYear(year: note.date.get(.year)) {
            formatter.dateFormat = "MMM d"
        } else {
            formatter.dateFormat = "MM/dd/yyyy"
        }
        dateLabel.text = formatter.string(from: note.date)
    }
    
    func configure(note: Note) {
        self.note = note
    }
    
    func prepareNote() {
        self.note = nil
    }
}
