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
    var nibIndex: Int { get }
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
        get { return (self.view as? VMView)?.viewModel }
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
    
    public class func instantiateWithViewModel(viewModel: VMViewModel) -> Self {
        let controller = self(nibName: viewModel.nibName, bundle: viewModel.bundle)
        controller.viewModel = viewModel
        return controller.reload(true)
    }
}


// MARK: Composition Functions

public func composeViewWithViewModel(viewModel: VMViewModel, owner ownerOrNil: AnyObject? = nil, options optionsOrNil: [NSObject : AnyObject]? = nil) -> VMView {
    let nib = UINib(nibName: viewModel.nibName, bundle: viewModel.bundle)
    let view = nib.instantiateWithOwner(ownerOrNil, options: optionsOrNil)[viewModel.nibIndex] as! VMView
    view.viewModel = viewModel
    return view
}


// MARK: Other Functions

public func reloadView<V: VMView>(view: V, fromModel: Bool = false) -> V {
    if fromModel {
        view.viewModel?.reload()
    }
    view.reload()
    return view
}