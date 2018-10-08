//
//  ViewController.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class ProPlayersTableViewController: UITableViewController {
  
  @IBAction func showInfo(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Pro Players Info", message: "This is a list of professional players of Dota 2. Please select one to see player's played hero per match", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  let cellIdentifier = "PlayerCell"
  let loadingIdentifier = "ActivityCell"
  let segueIdentifier = "toParticipants"
  
  private var token: NSKeyValueObservation?
  
  var isFirstTime = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .none
    
    refreshControl = UIRefreshControl()
    refreshControl?.tintColor = UIColor.darkGray
    refreshControl?.addTarget(self, action: #selector(fetchProPlayers), for: .valueChanged)
    
    token = ProPlayersService.service.observe(\.players) { _, _ in
      DispatchQueue.main.async {
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
      }
    }
    
    ProPlayersService.service.fetchProPlayers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if isFirstTime {
      refreshControl?.beginRefreshing()
      isFirstTime = false
    }
  }
  
  @objc func fetchProPlayers() {
    ProPlayersService.service.fetchProPlayers()
  }
  
}

// MARK: - UITableDataSource
extension ProPlayersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ProPlayersService.service.players.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlayerTableViewCell
    cell.player = ProPlayersService.service.players[indexPath.row]
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ProPlayersTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: segueIdentifier, sender: tableView)
  }
}

// MARK: - Prepare for Segue
extension ProPlayersTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier, tableView.indexPathForSelectedRow?.row != nil else { return }
    let vc = segue.destination as! MatchesTableViewController
    let index = tableView.indexPathForSelectedRow!.row
    vc.accountId = ProPlayersService.service.players[index].accountId
    vc.navigationItem.title = ProPlayersService.service.players[index].name
  }
}
