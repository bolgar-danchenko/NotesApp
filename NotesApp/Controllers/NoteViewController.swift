//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    private var noteId: String?
    private var index: Int = 0
    var noteCell: NoteTableViewCell?

    private lazy var titleTextField = TitleTextField(frame: .zero)
    private lazy var textView = TextView(frame: .zero)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        index = MainViewController.allNotes.firstIndex(where: {$0.id == noteId}) ?? 0
        
        self.navigationItem.largeTitleDisplayMode = .never
        setupNavigationBar()
        setupLayout()
        setupConstraints()

        titleTextField.delegate = self
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let note = MainViewController.allNotes[index]
        textView.text = note.text
        titleTextField.text = note.title
        view.backgroundColor = UIColor(named: note.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let noteCell = noteCell else {
            return
        }
        noteCell.configure(with: MainViewController.allNotes[index])
    }
    
    // MARK: - Layout
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupLayout() {
        view.addSubview(titleTextField)
        view.addSubview(textView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 30),
            
            textView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Setup
    
    func set(noteId: String) {
        self.noteId = noteId
    }
    
    func set(noteCell: NoteTableViewCell) {
        self.noteCell = noteCell
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TextView & TextFieldDelegate
extension NoteViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        MainViewController.allNotes[index].text = textView.text
        CoreDataManager.shared.save()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let input = textField.text else { return }
        
        MainViewController.allNotes[index].title = input
        CoreDataManager.shared.save()
    }
}
