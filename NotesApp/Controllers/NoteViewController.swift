//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    private var noteId: String!
    private var textView: UITextView!
    private var textField: UITextField!
    private var index: Int!
    var noteCell: CustomNoteTableViewCell?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        index = MainViewController.allNotes.firstIndex(where: {$0.id == noteId})!
        
        self.navigationItem.largeTitleDisplayMode = .never
        setupNavigationBarItem()
        setupTextView()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let note = MainViewController.allNotes[index]
        textView.text = note.text
        textField.text = note.title
        view.backgroundColor = UIColor(named: note.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let noteCell = noteCell else {
            return
        }
//        noteCell.prepareNote()
        noteCell.configure(with: MainViewController.allNotes[index])
    }
    
    private func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupTextView() {
        textView = CustomTextView(frame: .zero)
        view.addSubview(textView)
        textView.delegate = self
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height * 0.09),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -115),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -56)
        ])
    }
    
    private func setupTextField() {
        textField = CustomTextField(frame: .zero)
        view.addSubview(textField)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70)
        ])
    }
    
    func set(noteId: String) {
        self.noteId = noteId
    }
    
    func set(noteCell: CustomNoteTableViewCell) {
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
        MainViewController.allNotes[index].title = textField.text!
        CoreDataManager.shared.save()
    }
}
