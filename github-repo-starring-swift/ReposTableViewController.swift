

import UIKit


class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = store.repositories[indexPath.row]
        let repoName = repo.fullName
        store.toggleStarStatus(for: repoName) { (isStarred) in
            if isStarred == true {
               let starredAlert = UIAlertController(title: "Starred", message: "You just starrd \(repoName)", preferredStyle: .alert )
               let starredAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                starredAlert.addAction(starredAction)
                self.present(starredAlert, animated: true, completion: nil)
                
            } else {
                let unstarredAlert = UIAlertController(title: "Unstarred", message: "You just unstarrd \(repoName)", preferredStyle: .alert )
                let unstarredAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                unstarredAlert.addAction(unstarredAction)
                self.present(unstarredAlert, animated: true, completion: nil)
            }
        }
        
    }
    


}
