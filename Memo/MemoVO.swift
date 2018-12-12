//
//  MemoVO.swift
//  Memo
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import CoreData
class MemoVO{
    var num:Int32?
    var memoIdx : Int?
    var title : String?
    var contents : String?
    var image : UIImage?
    var date : Date?
    
    //하나의 MemoMO 인스턴스를 가리키기 위한 변수
    var objectID: NSManagedObjectID?
}
