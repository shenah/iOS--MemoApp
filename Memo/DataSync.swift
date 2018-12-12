//
//  DataSync.swift
//  Memo
//
//  Created by 503-03 on 07/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class DataSync {

    //코어데이터를 사용할려면 코어데이터에 접근하기 위한
    //포인터가 필요
    //코어데이터에 접근하는 포인터 생성
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    //날짜를 사용하는 경우는 날짜 포맷을 맞춰주는 메소드를 별도로 만들어
    //두는 것이 좋습니다.
    //Database <-> iOS 나 Android 이 방식의 통신이 안됩니다.
    //Database <-> RestAPI <-> iOS, Android
    
    //날짜를 데이터베이스에 yyyy-MM-dd HH:mm:ss 형식으로 저장
    //서버와 클라이언트 모두 저 형식에 맞추어서 데이터를 전송하고 받아야
    //합니다.
    //String -> Date
    func stringToDate(_ value: String) -> Date{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: value)!
    }
    //Date -> String
    func dateToString(_ value: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: value)
    }
    
    //서버에서 데이터를 다운로드 받아서 CoreData에 저장하는 메소드
    func downloadData(){
        //이 메소드를 한 번 호출해서 데이터를 다운로드 받으면
        //앱을 지우기 전까지는 다시는 다운로드 받지 않도록 생성
        //게임 애플리케이션에서 초기 데이터 가져올 때 사용하는 방법
        
        //UserDefaults : 앱의 설정 파일
        //앱을 지우기 전까지는 내용을 보존
        let userDefaults = UserDefaults.standard
        //특정 키의 값이 nil이 아니면 리턴
        //guard는 조건에 맞지 않으면 작업을 수행하지 않도록 하기 위해서 사용하는 경우가 많습니다.
        guard userDefaults.value(forKey: "download") == nil else{
            return
        }

        //다운로드 받을 서버의 url 만들기
        let url = "http://192.168.0.113:8080/APIServer/memo/memolist"
        //요청 보내기
        let get = Alamofire.request(url)
        get.responseJSON{
            res in
            //데이터 전체를 디셔너리로 변경
            guard let jsonObject = res.result.value as? NSDictionary else{return}
            //memo 키의 데이터를 list로 변환
            guard let list = jsonObject["memos"] as? NSArray else{return}
            //배열 순회
            for item in list{
                //하나하나의 항목을 디셔너리로 변경
                guard let record = item as? NSDictionary else{return}
                //CoreData의 자료형인 MemoMO 객체 만들
                let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
                object.num = record["NUM"] as! Int32
                object.title = (record["TITLE"] as! String)
                object.contents = (record["CONTENTS"] as! String)
                object.regdate = self.stringToDate(record["REGDATE"] as! String)
                if let imagePath = record["IMAGE_PATH"] as? String{
                    if imagePath == "http://192.168.0.201:8080/APIServer/memoimage/\(imagePath)"{
                        let u = URL(string: url)
                        object.image = try! Data(contentsOf: u!)
                    }
                }
            }
            //데이터를 코어 데이터에 저장
            do{
                try self.context.save()
            }catch let e as NSError{
                print("\(e.localizedDescription)")
            }
            //다운로드 받았다는 사실을 저장
            userDefaults.setValue(true, forKey:"download")
        }
        
    }
}
