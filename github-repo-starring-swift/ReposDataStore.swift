

import UIKit

// just for info - because the vc can't call API directly 
// put it in a singleton - so that way, the use of info in the entire application is accessed through the singleton
class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories{ (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                let repository = GithubRepository(dictionary: dictionary)
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    func toggleStarStatus(for fullName: String, completion: @escaping (Bool)->()){
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: fullName) { (isStarred) in
            if isStarred == true {
                GithubAPIClient.unstarRepository(fullName: fullName, completion: { 
                    completion(false)
                })
            } else {
                GithubAPIClient.starRepository(fullName: fullName, completion: { 
                    completion(true)
                })
            }
            
        }
    }

}





