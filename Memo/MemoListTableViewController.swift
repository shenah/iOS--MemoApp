//
//  MemoListTableViewController.swift
//  Memo
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dao = MemoDAO()
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    //이벤트 처리에 사용할 메소드
    @objc func add(_ barButtonItem: UIBarButtonItem){
        //MemoForm 출력
        let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC; self.navigationController?.pushViewController(memoFormVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션 바의 오른쪽에  + 버튼 배치
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MemoListTableViewController.add(_:)))
        
        if let revealVC = self.revealViewController(){
            //바 버튼 아이템 객체를 정의한다.
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.navigationItem.leftBarButtonItem = btn
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    //추가한 데이터를 재출력
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.memoList = self.dao.fetch()
        tableView.reloadData()
        searchbar.delegate = self
        searchbar.enablesReturnKeyAutomatically = false
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //행번호에 해당하는 데이터 찾아오기
        let memo = appDelegate.memoList[indexPath.row]
        
        //이미지 존재 여부에 따라 셀 모양을 다르게 설정
        let cellId = memo.image == nil ? "MemoCell" : "MemoCellWithImage"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        //print("cell:\(memo.title)")
        cell.subject.text = memo.title
        cell.contents.text = memo.contents
        
        //날짜를 원하는 형식대로 만들어 주는 객체 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.date.text = dateFormatter.string(from: memo.date!)
        //어떤 경우에는 존재하고 어떤경우에는 nil일 경우 img?를 사용하여 nil 저장 가능하게 만들어야 합니다.
        cell.img?.image = memo.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = appDelegate.memoList[indexPath.row]
        let memoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemoDetailViewController") as! MemoDetailViewController
        memoDetailViewController.memo = memo
        self.navigationController?.pushViewController(memoDetailViewController, animated: true)
        
    }
    
    //편집 기능을 실행할 때 보여질 버튼을 설정하는 메소드
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //행번호에 해당하는 데이터 찾아오기
        let data = self.appDelegate.memoList[indexPath.row]
        if dao.delete(data.objectID!){
            // 코어 데이터에서 삭제한 다음, 배열 내 데이터 및 테이블 뷰 행을 차례로 삭제한다.
            self.appDelegate.memoList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
}
extension MemoListTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        let dao = MemoDAO()
        self.appDelegate.memoList = dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
}
