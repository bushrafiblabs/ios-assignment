//
//  ViewController.swift
//  TestAssignment
//
//  Created by Bushra Sagir on 7/1/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


struct User {
  var name: String
  var image: String
  var items: [String]
  init(_ dictionary: [String: Any]) {
    self.name = dictionary["name"] as? String ?? ""
    self.image = dictionary["image"] as? String ?? ""
    self.items = dictionary["items"] as? [String] ?? []
  }
}


class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var model = [User]()
  let collectionViewHeaderReuseIdentifier = "MyHeaderView"

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGalleryView()
    callApi()
  }

  private func setupGalleryView() {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize =     CGSize(
      width: collectionView.frame.size.width,
      height: 64
    )
    collectionView.collectionViewLayout = layout
  }
  
  func callApi() {
    guard let url = URL(string: "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10")
      else {return}
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let dataResponse = data,
        error == nil else {
          print(error?.localizedDescription ?? "Response Error")
          return }
      do{
        //here dataResponse received from a network request
        let jsonResponse = try JSONSerialization.jsonObject(with:
          dataResponse, options: [])
        guard let jsonArray = (jsonResponse as? [String: Any]) else {
          return
        }
        guard let data = jsonArray["data"] as? [String: Any] else {
          return
        }
        guard let users = data["users"] as? [[String: Any]] else {
          return
        }
        for dic in users{
          self.model.append(User(dic)) // adding now value in Model array
        }
        print(self.model[0].name) // 1211
      } catch let parsingError {
        print("Error", parsingError)
      }
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
    task.resume()
  }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridViewCelll", for: indexPath as IndexPath) as? CollectionViewCell ?? UICollectionViewCell() as! CollectionViewCell
    let item = model[indexPath.section].items[indexPath.row]
    let imageUrl = URL(string: item)
    cell.itemImage.af_setImage(
      withURL: imageUrl!,
      placeholderImage: UIImage(named: "placeHolderImage"),
      imageTransition: .crossDissolve(0.2)
    )
  
    return cell
  }


  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let user = model[indexPath.section]
    switch kind {
      
    case UICollectionView.elementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseIdentifier, for: indexPath) as? SectionHeader
      
      headerView?.name.text = user.name
      headerView?.profileImage.clipsToBounds = true
      headerView?.profileImage.layer.cornerRadius = (headerView?.profileImage.frame.size.height ?? 44)/2
      let imageUrl = URL(string: user.image)
      if let size = headerView?.profileImage.frame.size {
        headerView?.profileImage.af_setImage(
          withURL: imageUrl!,
          placeholderImage: UIImage(named: "placeHolderImage"),
          filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 20.0),
          imageTransition: .crossDissolve(0.2)
        )
      }
      return headerView!
    default:
      assert(false, "Unexpected element kind")
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int  {
    //#warning Incomplete method implementation -- Return the number of sections
    return model.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //#warning Incomplete method implementation -- Return the number of items in the section
    var returnValue = 0
    if model.count > 0 {
      returnValue = model[section].items.count
    }
    return returnValue
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {    
    if collectionView.numberOfItems(inSection: 0) % 2 != 0 && indexPath.row == 0 {
      return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.width - 5) / 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
}
