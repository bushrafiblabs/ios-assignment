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

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var model = [User]()
  let collectionViewHeaderReuseIdentifier = "MyHeaderView"

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGalleryView()
    fetchAndPopullateUI()
  }

  private func fetchAndPopullateUI() {
    UserService.getUsers{ (users : [User]) in
      self.model = users
      DispatchQueue.main.async {
        //  Updating UI on main queue
        self.collectionView.reloadData()
      }
    }
  }

  private func setupGalleryView() {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 84)
    collectionView.collectionViewLayout = layout
  }
}

extension ViewController: UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: CollectionViewCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "gridViewCelll",
      for: indexPath as IndexPath
    ) as! CollectionViewCell
    let item = model[indexPath.section].items[indexPath.row]
    let imageUrl = URL(string: item)
    cell.itemImage.af_setImage(
      withURL: imageUrl!,
      placeholderImage: UIImage(named: "placeHolderImage"),
      imageTransition: .crossDissolve(0.2)
    )
    return cell
  }


  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let user = model[indexPath.section]
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: collectionViewHeaderReuseIdentifier,
        for: indexPath
      ) as? SectionHeader
      
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
    return model.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    var returnValue = 0
    if model.count > 0 {
      returnValue = model[section].items.count
    }
    return returnValue
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    if collectionView.numberOfItems(inSection: indexPath.section) % 2 != 0 && indexPath.row == 0 {
      return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.width - 5) / 2)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5
  }
}
