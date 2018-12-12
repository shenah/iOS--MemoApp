//
//  MemoDAO.swift
//  Memo
//
//  Created by 503-03 on 03/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import CoreData
class MemoDAO {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [MemoVO] {
        var memoList = [MemoVO]()
        
        //요청 객체 생성 - 반드시 MemoMO를 지정해야 합니다.
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        //최신 글 순으로 정렬하도록 정렬 객체 생성
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        do{
            let resultset = try self.context.fetch(fetchRequest)
            
            //읽어온 결과 집합을 순회하면서 [MemoData]타입으로 변환
            for record in resultset{
                let data = MemoVO()
                //MemoMO 프로퍼티 값을 MemoData의 프로퍼티로 복사한다.
                data.num = record.num
                data.title = record.title
                data.contents = record.contents
                //날짜를 형변환해서 저장 
                data.date = record.regdate! as Date
                data.objectID = record.objectID
                if let image = record.image as Data?{
                    data.image = UIImage(data: image)
                }
                memoList.append(data)
            }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
            
        }
        return memoList
    }
    
    func insert(_ data: MemoVO) {
        //관리 객체 인스턴스 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        
        //MemoVO로부터 값을 복사한다.
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.date!
        if let image = data.image {
            object.image = image.pngData()!
        }
        //영구 저장소에 변경 사항을 반영한다.
        do {
            try self.context.save()
        } catch let e as NSError {
            print("\(e.localizedDescription)")
        }
    }
    //삭제
    func delete(_ objectID: NSManagedObjectID) -> Bool{
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do{
            try self.context.save()
            return true
        }catch let e as NSError{
            print("\(e.localizedDescription)")
            return false
        }
    }
    
    //조건 검색
    func fetch(keyword : String? = nil) -> [MemoVO]{
        print(keyword)
        var memoList = [MemoVO]()
        //요청 객체 생성
        let fetchRequest:NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        //검색 조건
        if let t = keyword , t.isEmpty == false{
            fetchRequest.predicate = NSPredicate(format:"contents CONTAINS[c] %@", t)
        }
        //2개 이상의 데이터를 가져올 때는 정렬 조건을 추가
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        do{
            let resultSet = try self.context.fetch(fetchRequest)
            //데이터 순회
            for record in resultSet{
                //1개의 데이터를 저장할 객체를 생성
                let data = MemoVO()
                data.title = record.title
                data.contents = record.contents
                //날짜는 형변환해서 저장
                data.date = record.regdate! as Date
                //ID 저장
                data.objectID = record.objectID
                //image는 존재하면 변환해서 저장
                if let image = record.image as Data?{
                    data.image = UIImage(data: image)
                }
                //목록에 저장
                memoList.append(data)
            }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
        return memoList
    }

}
