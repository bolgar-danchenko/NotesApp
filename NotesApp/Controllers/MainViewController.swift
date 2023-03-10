//
//  NotesViewController.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 27.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    static var allNotes = [Note]()
    var searchedNotes = [Note]()
    
    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    // MARK: - Subviews
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor(named: "BG")
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No notes yet"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BG")
        
        setupLayout()
        setupConstraints()
        setupTableView()
        setupNavigationBar()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        
        fetchNotesFromStorage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeCellIfEmpty()
    }
    
    // MARK: - Layout
    
    private func setupNavigationBar() {
        title = "Notes"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapAddButton))
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Action
    
    @objc private func didTapAddButton() {
        let newNote = CoreDataManager.shared.createNote()
        MainViewController.allNotes.insert(newNote, at: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        tableView.endUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let vc = NoteViewController()
            vc.noteCell = nil
            vc.set(noteId: newNote.id)
            vc.set(noteCell: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NoteTableViewCell )
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Notes Storage
    func fetchNotesFromStorage() {
        MainViewController.allNotes = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNoteFromStorage(at index: Int) {
        CoreDataManager.shared.deleteNote(MainViewController.allNotes[index])
    }
    
    private func searchNotesFromStorage(_ text: String) {
        searchedNotes = CoreDataManager.shared.fetchNotes(filter: text)
        tableView.reloadData()
    }
    
    private func removeNote(row: Int, tableView: UITableView) {
        deleteNoteFromStorage(at: row)
        MainViewController.allNotes.remove(at: row)
        let path = IndexPath(row: row, section: 0)
        tableView.deleteRows(at: [path], with: .top)
    }
    
    private func removeCellIfEmpty() {
        guard let firstNoteCell = MainViewController.allNotes.first else { return }
        if firstNoteCell.title.trimmingCharacters(in: .whitespaces).isEmpty && firstNoteCell.text.trimmingCharacters(in: .whitespaces).isEmpty {
            removeNote(row: 0, tableView: tableView)
        }
    }
}

// MARK: - TableView Extensions

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if searchedNotes.isEmpty {
                emptyLabel.isHidden = false
            } else {
                emptyLabel.isHidden = true
            }
            return searchedNotes.count
        } else {
            if MainViewController.allNotes.isEmpty {
                emptyLabel.isHidden = false
            } else {
                emptyLabel.isHidden = true
            }
            return MainViewController.allNotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.id, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        if isSearching {
            cell.configure(with: searchedNotes[indexPath.row])
        } else {
            cell.configure(with: MainViewController.allNotes[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NoteViewController()
        if isSearching {
            vc.set(noteId: searchedNotes[indexPath.row].id)
        } else {
            vc.set(noteId: MainViewController.allNotes[indexPath.row].id)
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return }
        vc.set(noteCell: cell)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeNote(row: indexPath.row, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        }
        return true
    }
    
}

// MARK: - SearchController Extension

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        search(text: text)
    }
    
    func search(text: String) {
        searchNotesFromStorage(text)
    }
    
    
}
