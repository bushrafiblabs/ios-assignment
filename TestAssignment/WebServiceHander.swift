
import UIKit
import Alamofire

class UserService: NSObject {
  
  class func getUsers(completion: @escaping ([User]) -> ()) {
    let todoEndpoint: String = "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10"
    var json = NSDictionary()
    Alamofire.request(todoEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default)
      .responseJSON { response in
        switch response.result{
        case .success( _):
          json = response.result.value as! NSDictionary
          print("serviceForNewsFeed response \(json)")
          if let users = parseUserData(json) {
            completion(users)
          }
        case .failure(let error):
          print("error \(error)")
        }
    }
  }

  class func parseUserData(_ response: NSDictionary) -> [User]? {
    var model = [User]()
    guard let data = response["data"] as? NSDictionary else {
      return nil
    }
    guard let users = data["users"] as? [[String: Any]] else {
      return nil
    }
    for dic in users{
      model.append(User(dic)) // adding now value in Model array
    }
    return model
  }
}
