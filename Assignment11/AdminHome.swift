//
//  AdminHome.swift
//  Assignment11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AdminHome: UIViewController {
    
    
    private let myTable = UITableView()
    private let toolBar:UIToolbar = {
        let toolBar = UIToolbar()
        let item1 = UIBarButtonItem(barButtonSystemItem: .add, target:self, action: #selector(add_note))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, item1,space]
        return toolBar
    }()
    private var notes = [Student]()
    private let btnLogout:UIButton = {
        let btn = UIButton()
        btn.setTitle("LogOut", for: .normal)
        btn.addTarget(self, action: #selector(logoutclick), for: .touchUpInside)
        btn.tintColor = .white
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 6
        return btn
    }()
    @objc func logoutclick(){
        UserDefaults.standard.setValue(nil, forKey: "uname")
        self.dismiss(animated: true)
        let sc = Login()
        navigationController?.pushViewController(sc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(myTable)
        view.addSubview(toolBar)
        view.addSubview(btnLogout)
        myTable.dataSource = self
        myTable.delegate = self
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnLogout.frame = CGRect(x: 10, y: 25, width: 80, height: 30)
        toolBar.frame = CGRect(x: 0, y: 20, width: view.width, height: 40)
        myTable.frame = CGRect(x: 0,y: toolBar.bottom + 10, width: view.frame.size.width,
                               height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        notes = SQLiteHandler.shared.fetch()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        myTable.reloadData()
    }
    @objc func add_note()
    {
        let vc = StudentRegister()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension AdminHome: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let stud = notes[indexPath.row]
        cell.textLabel?.text = "\(stud.sname) \t | \t \(stud.course) \t | \t \(stud.gen)  \t | \t \(stud.email)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StudentRegister()
        vc.stud = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id = notes[indexPath.row].spid
        SQLiteHandler.shared.delete(for: id) { (success) in
            if success {
                print("Deleted in VC")
                self.notes.remove(at: indexPath.row)
                self.myTable.deleteRows(at: [indexPath], with: .automatic)
            } else {
                print(id)
                print("not Deleted in VC")
            }
        }
    }
    
}

