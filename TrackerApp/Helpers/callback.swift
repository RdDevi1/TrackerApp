//
//  Int+extension.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 03.04.2023.
//



//class ViewController: UIViewController {
//
//    var vc1 = ViewController1()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .red
//
//        vc1.callback = { [weak self] in
//            self?.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        present(vc1, animated: true)
//    }
//}
//
//class ViewController1: UIViewController {
//
//    var vc2 = ViewController2()
//
//    var callback: (() -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .green
//
//        vc2.callback = { [weak self] in
//            self?.callback?()
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        present(vc2, animated: true)
//    }
//
//}
//
//class ViewController2: UIViewController {
//
//    var callback: (() -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .blue
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        callback?()
//    }
//
//}
