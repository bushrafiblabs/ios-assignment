//
//  SectionHeader.swift
//  TestAssignment
//
//  Created by Bushra Sagir on 7/1/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var name: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
