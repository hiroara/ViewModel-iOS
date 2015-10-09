//
//  ViewController.swift
//  ViewModel
//
//  Created by Hiroki Arai on 3/30/15.
//  Copyright (c) 2015 Hiroki Arai. All rights reserved.
//

import UIKit
import ViewModel

class Model {
    var title: String
    var body: String
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

class ViewModel: VMViewModel {
    var model: Model
    var title: String?
    var body: String?
    override var nibName: String { return "BoxView" }

    required init(model: AnyObject) {
        self.model = model as! Model
        super.init(model: model)
        self.reload()
    }
    override func reload() -> Self {
        self.title = model.title
        self.body = model.body
        return self
    }
    override func apply() -> AnyObject {
        if let title = self.title {
            self.model.title = title
        }
        if let body = self.body {
            self.model.body = body
        }
        return self.model
    }
}

class BoxView: UIView, VMView {
    var viewModel: VMViewModel? = nil

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    func reload() -> Self {
        if let vm = self.viewModel as? ViewModel {
            self.titleLabel?.text = vm.title
            self.bodyLabel?.text = vm.body
        }
        return self
    }
    func didChangeViewModel(viewModel: VMViewModel, key: String) {}
}

class BoxViewController: UIViewController {
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let model = Model(title: "This is title", body: "This is body.\n\nAwesome text!")

        let controller = BoxViewController.instantiateWithViewModel(ViewModel(model: model))
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

