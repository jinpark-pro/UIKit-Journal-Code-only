//
//  ViewController.swift
//  JRN-CodeOnly
//
//  Created by Jungjin Park on 2024-05-13.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddJournalControllerDelegate {
    
    // 무거워서 lazy로 생성
    lazy var tableView: UITableView = {
        // 초기화
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // dequeue 를 위해서 queue에 넣어 놓는 작업
        tableView.register(JournalListTableViewCell.self, forCellReuseIdentifier: "journalCell")
        
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        // 가로 세로 체우는 작업
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        navigationItem.title = "Journal"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addJournal))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharedData.shared.loadJournalEntriesData()
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SharedData.shared.numberOfJournalEntries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalListTableViewCell
        let journalEntry = SharedData.shared.getJournalEntry(index: indexPath.row)
        cell.configureCell(journalEntry: journalEntry)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let journalEntry = SharedData.shared.getJournalEntry(index: indexPath.row)
        let journalDetailTableViewController = JournalDetailTableViewController(journalEntry: journalEntry)
        show(journalDetailTableViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SharedData.shared.removeJournalEntry(index: indexPath.row)
            SharedData.shared.saveJournalEntriesData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    // MARK: - Methods
    @objc private func addJournal() {
        let addJournalViewController = AddJournalViewController()
        let navController = UINavigationController(rootViewController: addJournalViewController)
        
        addJournalViewController.delegate = self
        
        present(navController, animated: true)
    }
    
    
    func saveJournalEntry(_ journalEntry: JournalEntry) {
        SharedData.shared.addJournalEntry(newJournalEntry: journalEntry)
        SharedData.shared.saveJournalEntriesData()
        tableView.reloadData()
    }
}

