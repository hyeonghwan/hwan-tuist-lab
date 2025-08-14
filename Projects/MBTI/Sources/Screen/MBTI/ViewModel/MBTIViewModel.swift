//
//  MBTIViewModel.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class MBTIViewModel {
    
    struct Input {
        let ei: LazyObservable<String>
        let sn: LazyObservable<String>
        let tf: LazyObservable<String>
        let jp: LazyObservable<String>
        let textEditingChanged: EagerObservable<String>
    }
    
    struct Output {
        let viewModelState: EagerObservable<State>
    }
    
    struct State {
        var mbtiState: [String]
        var inputStatus: InputStatus
        var photo: String
    }
    
    private var resultMBTI: [String] = ["", "", "", ""] {
        didSet {
            if case let .next(originState) = self.viewModelState.source {
                self.viewModelState.source = .next(
                    .init(
                        mbtiState: self.resultMBTI,
                        inputStatus: originState.inputStatus,
                        photo: originState.photo
                    )
                )
            }
        }
    }
    
    private var bag = Bag()
    
    // MARK: Input From PhotoSelectedViewController
    private(set) var selectedPhoto = LazyObservable<String>()
    
    // MARK: Output to PhotoSelectedViewController
    private(set) var photoListOutput = EagerObservable<[String]>(source: .next(Avatar.allCases.map(\.rawValue)))
    
    // MARK: OUTPUT
    private let viewModelState = EagerObservable<State>(
        source: .next(
            .init(
                mbtiState: ["", "", "", ""],
                inputStatus: .none,
                photo: Avatar.getRandomAvatarString()
            )
        )
    )
    
    var photo: String {
        viewModelState.value.photo
    }
    
    func transform(input: Input) -> Output {
        input.ei.subscribeOn { [weak self] letter in self?.resultMBTI[0] = letter }.disposed(in: bag)
        input.sn.subscribeOn { [weak self] letter in self?.resultMBTI[1] = letter }.disposed(in: bag)
        input.tf.subscribeOn { [weak self] letter in self?.resultMBTI[2] = letter }.disposed(in: bag)
        input.jp.subscribeOn { [weak self] letter in self?.resultMBTI[3] = letter }.disposed(in: bag)
        
        input.textEditingChanged
            .subscribeOn { [weak self] text in
                guard let self else { return }
                let status = text.isEmpty ? .none : InputStatus.validate(text).1
                let origin = self.viewModelState.value
                self.viewModelState.source = .next(
                    .init(
                        mbtiState: self.resultMBTI,
                        inputStatus: status,
                        photo: origin.photo
                    )
                )
            }
            .disposed(in: bag)
        
        
        selectedPhoto.subscribeOn { [weak self] avatar in
            guard let self else { return }
            let origin = self.viewModelState.value
            self.viewModelState.source = .next(
                .init(
                    mbtiState: origin.mbtiState,
                    inputStatus: origin.inputStatus,
                    photo: avatar
                )
            )
        }
        .disposed(in: bag)
        
        return Output(
            viewModelState: viewModelState
        )
    }
}
