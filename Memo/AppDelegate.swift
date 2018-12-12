//
//  AppDelegate.swift
//  Memo
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //모든 곳에서 사용할 수 있는 VO객체 생성
    var memoList = [MemoVO]()

    //애플리케이션이 시작될 때 호출되는 메소드
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dataSync = DataSync()
        //비동기적으로 실행 - 스레드
        DispatchQueue.global(qos: .background).async{
            dataSync.downloadData()
        }
        return true
    }

    //앱이 실행을 종료할 때 호출되는 메소드
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    //앱이 백그라운드로 진행하기 직전에 호출되는 메소드
    //앱을 종료하는 경우도 있지만 전화 등의 인터럽트가 발생한 경우에도 호출
    //실행 중에 필요한 데이터 저장(음악 재생의 경우는 재생 지점 을 저장)
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    //앱이 포그라운드로 갈 때 호출되는 메소드
    //앞에서 저장한 데이터를 가지고 작업을 계속 수행
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    //앱이 다시 포그라운드에 진입한 후 호출되는 메소드
    //UI갱신을 합니다.
    //여기서 viewDidLoad를 강제로 호출해서 데이터를 갱신해서 출력하는 경우가
    //많습니다.
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    //앱이 종료될 때 호출되는 메소드
    //중요한 데이터를 서버에 저장하는 코드를 작성
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }

    //이 코드들도 코어 데이터 프로젝트에만 존재하는 코드
    //코어 데이터에 접근하기 위한 포인터를 만드는 코드
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memo")
        container.loadPersistentStores() {
            if let error = $1 as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //코어 데이터의 내용을 저장하는 메소드
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}

