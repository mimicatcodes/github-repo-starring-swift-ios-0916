
import UIKit
import Foundation

class GithubAPIClient {
    typealias JSON = [String:Any]
    
    //custom object
    class func getRepositories(with completion: @escaping ([JSON]) -> ()) {
        
        let urlString = Secrets.gitHubURL
        
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let session = URLSession.shared
        
        let request = URLRequest(url: unwrappedURL)
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [JSON]
                completion(jsonArray)
            } catch {
                print("ERROR")
                return
            }
            
        })
        dataTask.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion:@escaping (Bool)->()){
        // When writing completion clousre, try to call it first by adding completion first below.
        
        var isStarred = false
        // 1. URL String
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalToken)"
        
        // 2. URL Creation
        let url = URL(string: urlString)
        
        // 3. URL Unwrapping
        guard let unwarppedUrl = url else {return}
        
        // 4. Make a session
        let session = URLSession.shared
        // OR let session = URLSession.configuration(.default)
        
        // 5. Make a request - ( if only Get is needed, no need to)
        var request = URLRequest(url: unwarppedUrl)
        
        // 6. Clarify what kind of request you want to make
        request.httpMethod = "GET"
        // if we don't specify httpMethod - get is set by default.
        // dataTast(with:url) --> GET only
        // post, delete, patch anything else need REQUEST
        // Request allows more configuration
        
        // 7. Make a task out of session
        let task = session.dataTask(with: request) { (data, response, error) in
            // statusCode is part of HTTPURLResponse - you can't access the property if it's not HTTP.
            
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            // OR: let httpResponse = reponse as! HTTPURLResponse
            
            if httpResponse.statusCode == 204 {
                isStarred = true
                
            } else if httpResponse.statusCode == 404{
                isStarred = false
            }
            
            completion(isStarred)
            // call this function inside the task
        }
        task.resume()
        
        // Data task runs asynchronously (Closures are not asynchronous)
        // if we don't kick of the task, nothing will happen! Start the task!
        
    }
    
    class func starRepository(fullName:String, completion:@escaping ()->()) {
        
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalToken)"
        
        let url = URL(string: urlString)
        
        guard let unwrappedUrl = url else{return}
        
        let session = URLSession.shared
        
        var request = URLRequest(url: unwrappedUrl)
        request.httpMethod = "PUT"
        
        //add a Header
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 204 {
                completion()
            }
        }
        
        dataTask.resume()
        
    }
    
    class func unstarRepository(fullName: String, completion:@escaping ()->()){
        
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalToken)"
        
        let url = URL(string: urlString)
        
        guard let unwrappedUrl = url else{ return }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: unwrappedUrl)
        
        request.httpMethod = "PUT"
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 204 {
                completion()
            }
        }
        
        dataTask.resume()
    }
    
}

