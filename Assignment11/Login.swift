//
//  Login.swift
//  Assignment11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class Login: UIViewController {

    var user = "Admin"
    var pass = "admin@123"
    
    private let loginlbl:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Admin Login"
        lbl.textColor = .blue
        lbl.font = UIFont.italicSystemFont(ofSize: 30)
        lbl.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        return lbl
    }()
    private let txtUname:UITextField = {
        let txt = UITextField()
        txt.textColor = .black
        txt.placeholder = "Enter UserName"
        txt.textAlignment = .center
        txt.layer.cornerRadius = 10.0
        txt.backgroundColor = .white
        txt.layer.borderWidth = 0
        txt.layer.shadowColor = UIColor.black.cgColor
        txt.layer.shadowOffset = CGSize(width: 4, height: 4)
        txt.layer.shadowOpacity = 0.5
        txt.layer.shadowRadius = 5.0
        return txt
    }()
    private let txtPwd:UITextField = {
        let txt = UITextField()
        txt.textColor = .black
        txt.placeholder = "Enter Password"
        txt.isSecureTextEntry = true
        txt.textAlignment = .center
        txt.layer.cornerRadius = 10.0
        txt.backgroundColor = .white
        txt.layer.borderWidth = 0
        txt.layer.shadowColor = UIColor.black.cgColor
        txt.layer.shadowOffset = CGSize(width: 4, height: 4)
        txt.layer.shadowOpacity = 0.5
        txt.layer.shadowRadius = 5.0
        return txt
    }()
    private let btnLogin:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 0.4, green: 0.2, blue: 1.5, alpha: 0.5)
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.5
        return btn
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginlbl.frame = CGRect(x: 80, y: 80, width: 200, height: 100)
        txtUname.frame = CGRect(x: 40, y: loginlbl.bottom + 30, width: view.frame.size.width - 80, height: 40)
        txtPwd.frame = CGRect(x: 40, y: txtUname.bottom + 30 , width: view.frame.size.width - 80, height: 40)
        btnLogin.frame = CGRect(x: 40, y: txtPwd.bottom + 30, width: view.frame.size.width - 80, height: 40)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundimg.jpgeg")!)
        view.backgroundColor = .white
        view.addSubview(loginlbl)
        view.addSubview(txtUname)
        view.addSubview(txtPwd)
        view.addSubview(btnLogin)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @objc func loginClick(){
        if txtUname.text == user && txtPwd.text == pass {
            UserDefaults.standard.setValue(txtUname.text, forKey: "uname")
            self.dismiss(animated: true)
            let sc = AdminHome()
            navigationController?.pushViewController(sc, animated: true)
        }else{
            txtUname.text=""
            txtPwd.text=""
            let alert = UIAlertController(title: "Failed to LoggedIn", message: "Incorrect Username OR Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


}
