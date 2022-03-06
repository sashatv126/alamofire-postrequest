//
//  ViewController.swift
//  PracticeWithAlomofire
//
//  Created by Владимир on 06.03.2022.
//

import UIKit
import SnapKit
import Alamofire
class RequestViewController: UIViewController {
//MARK: -Views
    private lazy var scrollView : UIScrollView = {
       let scroll = UIScrollView()
        return scroll
    }()
    private lazy var stackViewText : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    private lazy var stackViewTButton : UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    private lazy var textFieldBirth : UITextField = {
        let text = UITextField()
        text.keyboardType = .numberPad
        text.borderStyle = .roundedRect
        text.placeholder = "Enter birth"
        text.textContentType = .telephoneNumber
        return text
    }()
    private lazy var textFieldOccupation : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter occupation"
        return text
    }()
    private lazy var textFieldName : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter name"
        return text
    }()
    private lazy var textFieldLastname : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter lastname"
        return text
    }()
    private lazy var textFieldcountry : UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Enter country"
        return text
    }()
    private lazy var URLbutton : UIButton = {
        let button = UIButton()
        button.setTitle("URL", for: .normal)
        button.addTarget(.none, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .green
        return button
    }()
    private lazy var AFbutton : UIButton = {
        let button = UIButton()
        button.setTitle("ALOMOFIRE", for: .normal)
        button.addTarget(.none, action: #selector(buttonAFTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .green
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        textDelegate()
        setupVIews()
        setupConstraints()
    }
//MARK: -Private func
    private func setupVIews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewText)
        scrollView.addSubview(stackViewTButton)
        stackViewText.addArrangedSubview(textFieldBirth)
        stackViewText.addArrangedSubview(textFieldOccupation)
        stackViewText.addArrangedSubview(textFieldName)
        stackViewText.addArrangedSubview(textFieldLastname)
        stackViewText.addArrangedSubview(textFieldcountry)
        stackViewTButton.addArrangedSubview(URLbutton)
        stackViewTButton.addArrangedSubview(AFbutton)
        view.backgroundColor = .white
    }
    private func setupConstraints() {
        scrollView.snp.makeConstraints{maker in
            maker.left.right.equalTo(view.safeAreaLayoutGuide).inset(0)
            maker.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
        stackViewText.snp.makeConstraints{maker in
            maker.top.equalTo(scrollView).inset(70)
            maker.centerX.equalTo(scrollView)
            maker.left.right.equalTo(scrollView).inset(20)
        }
        URLbutton.snp.makeConstraints{maker in
            maker.width.equalTo(120)
        }
        AFbutton.snp.makeConstraints{maker in
            maker.width.equalTo(120)
        }
        
        stackViewTButton.snp.makeConstraints{maker in
            maker.bottom.equalTo(stackViewText).offset(200)
            maker.centerX.equalTo(scrollView)
        }
        textFieldBirth.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldOccupation.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldName.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldLastname.snp.makeConstraints{maker in maker.width.equalTo(400)}
        textFieldcountry.snp.makeConstraints{maker in maker.width.equalTo(400)}
    }
    private func textDelegate() {
        textFieldBirth.delegate = self
        textFieldOccupation.delegate = self
        textFieldName.delegate = self
        textFieldLastname.delegate = self
        textFieldcountry.delegate = self
    }
    private func text() -> (Int,String,String,String,String){
        let birth = Int(textFieldBirth.text ?? "") ?? 0
        let occupation = (textFieldOccupation.text ?? "")
        let name = (textFieldName.text ?? "")
        let LastName = (textFieldLastname.text ?? "")
        let country = (textFieldcountry.text ?? "")
        return (birth,occupation,name,LastName,country)
    }
    @objc private func buttonTapped() {
        let item = JSONModel(birth: text().0, occupation: text().1, name: text().2, lastname: text().3, country: text().4)
        let json = try? JSONEncoder().encode(item)
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        URLSession.shared.dataTask(with: request){[weak self] (data, responce, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                        self?.aleartController(title: "Warning", message: "ERROR")
                     return
                }
                self?.aleartController(title: "Warning", message: "Sucsess")
            
            let r = try? JSONSerialization.jsonObject(with: data, options: [])
              if let r = r as? [String: Any]{print(r)}
            }
        }
        .resume()
}
    @objc private func buttonAFTapped() {
        let item = JSONModel(birth: text().0, occupation: text().1, name: text().2, lastname: text().3, country: text().4)
        
        AF.request("https://jsonplaceholder.typicode.com/posts",method: .post, parameters: item, encoder: JSONParameterEncoder.default).response { responce in
            guard responce.error == nil else {
                self.aleartController(title: "Warning", message: "ERROR")
                return
            }
            self.aleartController(title: "Warning", message: "Sucsess")
            debugPrint(responce)
        }
    }
}
//MARK: -Extesion
extension RequestViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldBirth.resignFirstResponder()
        textFieldOccupation.resignFirstResponder()
        textFieldName.resignFirstResponder()
        textFieldLastname.resignFirstResponder()
        textFieldcountry.resignFirstResponder()
        return true
    }
}
