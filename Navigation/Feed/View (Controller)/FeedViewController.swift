//
//  FeedViewController.swift
//  Navigation
//
//  Created by Олеся on 14.03.2022.
//

import UIKit

infix operator ?=

extension String {
    static func ?= (left: String?, right: String) -> Bool {
        let word = left != nil ? left : right
        return left == word
    }
}

protocol FeedModelProtocol: AnyObject {
    func check(word: String) -> Bool
}

class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModel
    private var result: Bool?
    private var timer = Timer()
    private var counter = 0
    var coordinator: FeedCoordinator
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: view.center.x - 100, y: 100, width: 200, height: 50))
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.alpha = 0.5
        return label
    }()
    
    private lazy var textField: CustomTextField = {
        let textField = CustomTextField(borderStyle: .roundedRect, clearButton: .whileEditing, color: .systemBlue)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = false
        return textField
    }()
    
    private lazy var secondButton: CustomButton = {
        let button = CustomButton(title: NSLocalizedString("Log In", comment: "") , background: .black, titleColor: .systemYellow)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPush(_:)), for: .touchUpInside)
        return button
    }()
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle{
        get {
            return .dark
        }
        set {
            
        }
    }
    
    init(viewModel: FeedViewModel, coordinator: FeedCoordinator){
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preconditionGuard(loaded: self.isViewLoaded)
        view.backgroundColor = .lightGray
        title = NSLocalizedString("Feed", comment: "")
        navigationItem.title = NSLocalizedString("Feed", comment: "") 
        view.addSubview(stackView)
        view.addSubview(label)
        stackViewLayout()
        viewModel.changeState(action: .viewIsReady)
        getTimer()
        setColor()
    }
    
    //        override func viewWillAppear(_ animated: Bool) {
    //            super.viewWillAppear(animated)
    //            textField.text = ""
    //            label.text = ""
    //        }
    //    Я закомментировала данный код, чтобы результат проверки при возврате на этот контроллер было видно.Если надо . могу убрать просто эту проверку и оставить этот код- в таком случае при возврате на этот экран поле ввода и лейбл будут пустыми
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    //     это для того, чтобы если мы переходим по таббару в профиль например - таймер и  цикл в нем не работал и не выполнял лишнюю работу
    
    
    @objc private func buttonPush(_ sender: UIButton) {
        guard let word = textField.text else {return}
        if word ?= "" {
            viewModel.word = word
            viewModel.changeState(action: .buttonTapped)
            result = viewModel.result
            coordinator.check = { [weak self] in
                guard let result = self?.result else {return false}
                return result
            }
            if result  == true {
                label.text = word
                label.textColor = .systemGreen
//                print("На логин  у пользователя ушло \(counter) секунд.")
            } else {
                label.textColor = .red
            }
        }
        
        textField.resignFirstResponder()
        coordinator.setUp()
    }
    
    @objc private func actionTimer()  {
        counter += 1
        label.text = "\(counter) \(NSLocalizedString("seconds", comment: ""))"
        do{ try throwing(counter: counter)}
        catch VCErrors.forgotPas {
            print("CATCH VCErrors.forgotPas")
            let alert = UIAlertController(title: "Maybe you forgot correct password and login", message: "You didn't write right password. Correct password is \"Password\"" , preferredStyle: .alert)
            let act = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(act)
            present(alert, animated: true)
        } catch {
            ()
        }
    }
    
    private func stackViewLayout() {
        [textField, secondButton].forEach{ stackView.addArrangedSubview($0)}
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 170),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 50),
            secondButton.heightAnchor.constraint(equalToConstant: 50),
            textField.widthAnchor.constraint(equalToConstant: 200),
            secondButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func getTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer), userInfo: nil, repeats: true)
    }
    
    private func throwing(counter: Int) throws {
        if counter == 100 {
            throw VCErrors.forgotPas
        }
    }
    
    private func preconditionGuard(loaded: Bool) {
        precondition(loaded)
//        print("Precondition  - \(loaded)")
        guard let view = self.viewIfLoaded else {return}
//        print("CAN USERS ENABLED WITH VIEW - \(view.isUserInteractionEnabled)")
        
    }
}


extension FeedViewController:SetThemeColorProtocol {
    func setColor() {
        view.backgroundColor = .themeColor
        secondButton.backgroundColor = .buttonColor
        secondButton.tintColor = .textColor
        label.textColor = .textColor
        label.backgroundColor = .labelColor
        textField.backgroundColor = .labelColor
        textField.textColor = .textColor
    }
}


//идея в том, чтобы в консоль выводилось время, которое понадобилось пользователю для логина
// по домашнему заданию по обработке ошибок идея в том, чтобы через минуту после начала ввода пароля в поле при неправильном вводе выводился мессадж, что возможно пароль забыт и напоминалка для юзера...в консоль выходит также время, которое понадобилось юзеру для входа и естественно ошибка в консоль в  файле FEED View Controller
