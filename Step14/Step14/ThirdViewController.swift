//
//  ThirdViewController.swift
//  Step14
//
//  Created by omura.522 on 2016/07/04.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import Firebase

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var notification: UILabel!
    let rootRef = FIRDatabase.database().reference()
    var contentArray: [FIRDataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var snap: FIRDataSnapshot!
    
    /// ログアウト
    @IBAction func logout(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            let storyboard: UIStoryboard = self.storyboard!
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "first") as! FirstViewController
            self.present(firstViewController, animated: true, completion: nil)
        } catch let error as NSError {
            self.notification.numberOfLines = 2
            self.notification.text = "Logout failed! \n \(error.userInfo["NSLocalizedDescription"]!)"
        }
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでusersを指定することで、ユーザーが登録したデータの一つ上のchildまで指定することになる
        self.rootRef.child("users").queryOrdered(byChild: "point").observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                //データ数
                print("snapShots.children...\(snapShots.childrenCount)")
                //読み込んだデータ
                print("snapShot...\(snapShots)")
                
                self.snap = snapShots
            }
            self.reload(snap: self.snap)
        })
    }
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: FIRDataSnapshot) {
        //FIRDataSnapshotが存在するか確認
        if snap.exists() {
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                // pointが多いもの順になるように追加する
                contentArray.insert(item as! FIRDataSnapshot, at: 0)
            }
            //テーブルビューをリロード
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.read()
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        let item = contentArray[indexPath.row]
        let content = item.value
        if let name = content?["name"], point = content?["point"] {
            cell.textLabel!.text = "name: \(name!) point: \(point!)"
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        rootRef.removeAllObservers()
    }
}


