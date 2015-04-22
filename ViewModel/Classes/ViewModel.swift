//
//  ViewModel.swift
//  ViewModel
//
//  Created by Hiroki Arai on 3/30/15.
//  Copyright (c) 2015 Hiroki Arai. All rights reserved.
//

import UIKit

@objc public protocol VMViewModel {
    var nibName: String { get }
    weak var delegate: VMView? { get set }
    init(model: AnyObject)
    func reload() -> Self
    func apply() -> AnyObject
}

@objc public protocol VMView {
    var viewModel: VMViewModel? { get set }
    func reload() -> Self
    optional func didChangeViewModel(viewModel: VMViewModel, key: String)
}

public struct VMComposer<C: UIViewController> {
    public init() {}
    public func composeWith(#viewModel: VMViewModel) -> C {
        let controller = C(nibName: viewModel.nibName, bundle: nil)
        controller.viewModel = viewModel
        return controller
    }
}

public extension UIViewController {
    var viewModel: VMViewModel? {
        get { return (self.view as! VMView).viewModel }
        set {
            let vmView = self.view as! VMView
            vmView.viewModel = newValue
            newValue?.delegate = vmView
        }
    }

    func reload(fromModel: Bool) -> Self {
        if fromModel {
            self.viewModel?.reload()
        }
        (self.view as! VMView).reload()
        return self
    }
}
