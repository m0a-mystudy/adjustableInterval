//
//  ViewController.swift
//  adjustableInterval
//
//  Created by m0a on 2015/12/28.
//  Copyright © 2015年 m0a. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public func interval(throttle throttle:Variable<Double>) -> Observable<Double> {
    
    return create { (observer) -> Disposable in
        
        var intervalDisposer:Disposable?
        return throttle.subscribeNext { (chagedValue) -> Void in
            intervalDisposer?.dispose()
            intervalDisposer = interval(chagedValue, MainScheduler.sharedInstance).subscribeNext({ count -> Void in
                observer.on(.Next(chagedValue))
            })
        }
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var incrementalLabel: UILabel!
    @IBOutlet weak var addDurationButton: UIButton!
    @IBOutlet weak var decDurationButton: UIButton!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    var durationTime = Variable(0.3)
    var incrementValue = Variable(0)

    var disposeBag:DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interval(throttle: durationTime).subscribeNext { _ in
            self.incrementValue.value += 1
        }.addDisposableTo(disposeBag)
        

        //txt
        incrementValue.map{ return "\($0)"}.bindTo(incrementalLabel.rx_text).addDisposableTo(disposeBag)

        //chnage durationtime
        
        
        addDurationButton.rx_tap.subscribeNext {
            self.durationTime.value += 0.1
            self.durationTime.value = abs(self.durationTime.value)
        }.addDisposableTo(disposeBag)

        decDurationButton.rx_tap.subscribeNext {
            self.durationTime.value -= 0.1
            self.durationTime.value = abs(self.durationTime.value)
        }.addDisposableTo(disposeBag)

        self.durationTime.map{ return "\($0)" }.bindTo(durationTimeLabel.rx_text).addDisposableTo(disposeBag)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

