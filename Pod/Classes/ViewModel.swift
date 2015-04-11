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
    init(model: AnyObject)
    func reload() -> Self
    func apply() -> AnyObject
}

@objc public protocol VMView {
    func reload() -> Self
    var viewModel: VMViewModel? { get set }
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
        set { (self.view as! VMView).viewModel = newValue }
    }

    func reload(fromModel: Bool) -> Self {
        if fromModel {
            self.viewModel?.reload()
        }
        (self.view as! VMView).reload()
        return self
    }
}
