//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    //데이터 넘겨받을 변수
    var memo : MemoVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject.text = memo?.title
        contents.text = memo?.contents
        img?.image = memo?.image

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
