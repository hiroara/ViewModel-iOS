//
//  ViewModel.swift
//  ViewModel
//
//  Created by Hiroki Arai on 3/30/15.
//  Copyright (c) 2015 Hiroki Arai. All rights reserved.
//

import UIKit

public protocol VMViewModelType: class {
    var nibName: String { get }
    var nibIndex: Int { get }
    var bundle: NSBundle? { get }
    weak var delegate: VMView? { get set }
    init(model: AnyObject)
    func reload() -> Self
    func apply() -> AnyObject
    func fieldChangeNamed(name: String, value: AnyObject?)
}

public class VMViewModel: VMViewModelType {
    public var nibName: String { fatalError("Must be overridden") }
    public var nibIndex: Int = 0
    public var bundle: NSBundle? = nil
    public weak var delegate: VMView?
    public required init(model: AnyObject) {}
    public func reload() -> Self { return self }
    public func apply() -> AnyObject { fatalError("Must be overridden") }
    public func fieldChangeNamed(name: String, value: AnyObject?) {}
}


public extension VMViewModel {
    public var nib: UINib { return UINib(nibName: self.nibName, bundle: self.bundle) }

    public func composeViewWithOwner(ownerOrNil: AnyObject? = nil, options optionsOrNil: [NSObject : AnyObject]? = nil) -> VMView {
        let view = self.nib.instantiateWithOwner(ownerOrNil, options: optionsOrNil)[self.nibIndex] as! VMView
        view.viewModel = self
        return view
    }
}


public protocol VMView: class {
    var viewModel: VMViewModel? { get set }
    func reload() -> Self
    func didChangeViewModel(viewModel: VMViewModel, key: String)
}

// MARK: Other Functions

public extension VMView {
    public func reload(fromModel: Bool = false) -> Self {
        if fromModel {
            self.viewModel?.reload()
        }
        return self.reload()
    }
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
        let controller = self.init(nibName: viewModel.nibName, bundle: viewModel.bundle)
        controller.viewModel = viewModel
        return controller.reload(true)
    }
}

