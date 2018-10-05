//
//  PlayedWithTableViewController.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {
  
  // Pagination properties
  var offset = 0
  var limit = 10
  
  var isLoading = false
  
  let cellIdentifier = "MatchesCell"
  let loadingIdentifier = "ActivityCell"
  
  var accountId: Int?
  
  private var tokenMatches: NSKeyValueObservation?
  private var tokenHeroes: NSKeyValueObservation?
  
  // MARK: - Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.separatorStyle = .none
      
      refreshControl = UIRefreshControl()
      refreshControl?.addTarget(self, action: #selector(refreshMatches), for: .valueChanged)
      
      tokenHeroes = MatchesService.service.observe(\.heroesDic) { [weak self] _, _ in
        DispatchQueue.main.async {
          if !MatchesService.service.matches.isEmpty  {
            self?.tableView.reloadData()
          }
        }
      }
      
      tokenMatches = MatchesService.service.observe(\.matches) { [weak self] _, _ in
        guard self == self else { return }
        
        if MatchesService.service.matches.isEmpty && MatchesService.service.isForceRefresh {
          self!.offset = 0
          self!.firstPageLoad()
          return
        }
        
        self!.isLoading = false
        
        let arrayOfIndexes = Array(self!.offset..<self!.offset + self!.limit)
        let indexPathsToInsert = arrayOfIndexes.filter { MatchesService.service.matches.indices.contains($0)}
          .map { IndexPath(row: $0, section: 0) }
        
        DispatchQueue.main.async {
          self!.tableView.performBatchUpdates({
            self!.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .none)
            self!.tableView.insertRows(at: indexPathsToInsert, with: .none)
          }, completion: nil)
          self!.tableView.separatorStyle = MatchesService.service.matches.isEmpty ? .none : .singleLine
          self!.refreshControl?.endRefreshing()
        }
      }
      
      
      // Fetch Hero names
      // change 0 to a value to check table view reload
      DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
        MatchesService.service.fetchHeroes()
      }
      
      firstPageLoad()
    }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    tokenMatches?.invalidate()
    tokenHeroes?.invalidate()
  }
  
  deinit {
    MatchesService.service.eraseData()
  }
  
  
  private func firstPageLoad() {
    if let accountId = accountId {
      refreshControl?.beginRefreshing()
      MatchesService.service.fetchMatches(accountId: accountId, offset: self.offset, limit: self.limit)
    }
  }
  
  @objc private func refreshMatches() {
    MatchesService.service.changeRefreshStatus()
    let indicesToDelete = Array(0..<tableView.numberOfRows(inSection: 0))
    let indexPathsToDelete = indicesToDelete.map { IndexPath(row: $0, section: 0) }
    tableView.separatorStyle = .none
    tableView.performBatchUpdates({
      tableView.deleteRows(at: indexPathsToDelete, with: .none)
      MatchesService.service.eraseMatches()
    }, completion: nil)
  }

    // MARK: - Table View Data Source
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 0 {
        return MatchesService.service.matches.count
      } else if section == 1 && isLoading {
        return 1
      }
      return 0
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MatchesTableViewCell
        cell.match = MatchesService.service.matches[indexPath.row]
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: loadingIdentifier, for: indexPath) as! ActivityIndicatorCell
        cell.activityIndicator.startAnimating()
        return cell
      }
    }
}

// MARK: - UITableViewDelegate
extension MatchesTableViewController {

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    guard !isLoading, indexPath.section == 0 else { return }
    
    let totalRowsInSection = tableView.numberOfRows(inSection: 0)
    
    // change integer value to preload cells faster/slower
    if indexPath.row == totalRowsInSection - 5 {
      getNewMatches()
    }
  }
  
  func getNewMatches() {
    isLoading = true
    
    // looks like willDisplayCell is not running on the main thread, so we need to dispatch
    DispatchQueue.main.async {
      self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .none)
    }
    
    offset += limit
    MatchesService.service.fetchMatches(accountId: accountId!, offset: offset, limit: limit)
  }
}
