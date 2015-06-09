//
//  ViewModel.swift
//  ViewModel
//
//  Created by Hiroki Arai on 3/30/15.
//  Copyright (c) 2015 Hiroki Arai. All rights reserved.
//

import UIKit

public protocol VMViewModel: class {
    var nibName: String { get }
    var bundle: NSBundle? { get }
    weak var delegate: VMView? { get set }
    init(model: AnyObject)
    func reload() -> Self
    func apply() -> AnyObject
    func fieldChangeNamed(name: String, value: AnyObject?)
}

public protocol VMView: class {
    var viewModel: VMViewModel? { get set }
    func reload() -> Self
    func didChangeViewModel(viewModel: VMViewModel, key: String)
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


// MARK: Composition Functions

public func composeControllerWith<C: UIViewController>(#viewModel: VMViewModel) -> C {
    let controller = C(nibName: viewModel.nibName, bundle: viewModel.bundle)
    controller.viewModel = viewModel
    return controller
}
public func composeViewWith<V: VMView>(#viewModel: VMViewModel, index: Int, owner ownerOrNil: AnyObject? = nil, options optionsOrNil: [NSObject : AnyObject]? = nil) -> V {
    let nib = UINib(nibName: viewModel.nibName, bundle: viewModel.bundle)
    let view = nib.instantiateWithOwner(ownerOrNil, options: optionsOrNil)[index] as! V
    view.viewModel = viewModel
    return view
}
public func composeViewWith<V: VMView, VM: VMViewModel>(#model: AnyObject, index: Int, owner ownerOrNil: AnyObject? = nil, options optionsOrNil: [NSObject : AnyObject]? = nil) -> V {
    let viewModel = VM(model: model)
    return composeViewWith(viewModel: viewModel, index, owner: ownerOrNil, options: optionsOrNil)
}


// MARK: Other Functions

public func reloadView<V: VMView>(view: V, fromModel: Bool = false) -> V {
    if fromModel {
        view.viewModel?.reload()
    }
    view.reload()
    return view
}