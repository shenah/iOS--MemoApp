//
//  SideBarVC.swift
//  Memo
//
//  Created by 503-03 on 30/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class SideBarVC: UITableViewController {
    let titles = ["메모 작성", "친구 새글", "달력보기", "공지사항", "통계", "계정 관리"]
    let icons = [UIImage(named: "icon01.png"),
                 UIImage(named: "icon02.png"),
                 UIImage(named: "icon03.png"),
                 UIImage(named: "icon04.png"),
                 UIImage(named: "icon05.png"),
                 UIImage(named: "icon06.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = UIColor.brown
        self.tableView.tableHeaderView = headerView
        
        let defaultProfile = UIImageView(image: UIImage(named: "account.jpg"))
        defaultProfile.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        //이미지 라운드 처리
        defaultProfile.layer.cornerRadius = defaultProfile.frame.width/2
        //반원형태로 라운딩
        defaultProfile.layer.borderWidth = 0
        defaultProfile.layer.masksToBounds = true
        view.addSubview(defaultProfile)
        
        
        let nameLabel = UILabel(frame: CGRect(x: 70, y: 15, width: 100, height: 30))
        nameLabel.text = "tictok"
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.backgroundColor = UIColor.clear
        headerView.addSubview(nameLabel)
        
        let emailLabel = UILabel(frame: CGRect(x: 70, y: 30, width: 100, height: 30))
        emailLabel.text = "shenah@naver.com"
        emailLabel.textColor = UIColor.white
        emailLabel.font = UIFont.boldSystemFont(ofSize: 11)
        emailLabel.backgroundColor = UIColor.clear
        headerView.addSubview(emailLabel)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            // 화면 출력
            target.pushViewController(uv, animated: true)
            //sidebar 제거
            self.revealViewController().revealToggle(self)
        }else if indexPath.row == 5{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            // 화면 출력
            target.pushViewController(uv, animated: true)
            //sidebar 제거
            self.revealViewController().revealToggle(self)
        }
    }
 
}
