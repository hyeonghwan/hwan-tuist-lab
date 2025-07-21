//
//  ChatRoomViewController.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

// - 채팅 버블 날짜를 11:11 오전 형태로 구성합니다.                   O
// - 고정된 형태로 채팅버블을 구성하되, Dynamic Height 대응하기        O
// - 채팅 목록이 긴 경우, 테이블뷰의 스크롤을 가장 하단으로 내려보기        O
// - 오토레이아웃 수정을 통해 글자에 따라 채팅버블 유동적으로 조절하기       O
// - 날짜가 달라졌을 때, 날짜 구분선 넣어보기                         O
// - ‘메시지를 입력하세요’ 라인 텍스트뷰를, 세줄까지 늘려보기 (카카오톡처럼)  O
// - 실제로 전송 버튼 클릭 시 채팅 데이터 추가하기                      O

typealias ChatViewModel = ChatRoomViewController.ChatViewModel

final class ChatRoomViewController: UIViewController, CellIdentifialble {
    
    enum Section {
        case model(ChatViewModel)
    }
    
    struct ChatSection: Hashable {
        let date: Date // 섹션을 구분할 날짜 (시간은 제거된 yyyy-MM-dd)
        var items: [ChatViewModel]
    }

    struct ChatViewModel: Hashable {
        let chat: Chat
        var isTruncated: CGFloat?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(chat.id)
        }
        
        static func == (lhs: ChatViewModel, rhs: ChatViewModel) -> Bool {
            lhs.chat.id == rhs.chat.id
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageInputView: MessageInputView!
    @IBOutlet weak var inputViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var inputContainerView: UIView!
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageGen.paper_plane, for: .normal)
        button.setImage(ImageGen.paper_plane?.withTintColor(.secondaryLabel), for: .disabled)
        button.isEnabled = false
        return button
    }()
    var chatRoom: ChatRoom?
    private var sectionModels: [ChatSection] = []
    private var isScrolledToBottom: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = chatRoom?.chatroomName ?? ""
        chatRoomSetting()
        messageInputViewSetting()
        collectionViewSetting()
        sendButtonSetting()
        gestureSetting()
        keyboardSetting()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    private func keyboardSetting() {
        NotificationCenter.default
            .addObserver(self,
                selector: #selector(keyboardWillShow(notification:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
    }
    
    private func chatRoomSetting() {
        let initialChats: [ChatViewModel] = (chatRoom?.chatList ?? []).map {
            ChatViewModel(chat: $0, isTruncated: nil)
        }
        
        let groupedByDate = Dictionary(grouping: initialChats) { viewModel in
            let dateKey = String(viewModel.chat.date.prefix(10))
            return dateKey
        }
        let sortedKeys = groupedByDate.keys.sorted()
        self.sectionModels = sortedKeys.map { key in
            let date = key.toDate("yyyy-MM-dd") ?? Date()
            return ChatSection(date: date, items: groupedByDate[key] ?? [])
        }
    }
    
    private func gestureSetting() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tapGestureOccur(_:)))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    private func sendButtonSetting() {
        self.inputContainerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            inputContainerView.trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: 12),
            inputContainerView.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 12)
        ])
        sendButton.addTarget(self, action: #selector(messageSend(_:)), for: .touchUpInside)
    }
    
    private func collectionViewSetting() {
        let layout = BottomAlignedFlowLayout()
        layout.minimumLineSpacing = 8
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: ChatOtherCell.id, bundle: nil),
            forCellWithReuseIdentifier: ChatOtherCell.id
        )
        collectionView.register(
            UINib(nibName: ChatMeCell.id, bundle: nil),
            forCellWithReuseIdentifier: ChatMeCell.id
        )
        collectionView.register(
            SectionDateHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionDateHeaderView.id
        )
        
        collectionView.allowsSelection = false
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func messageInputViewSetting() {
    }
    @objc
    private func tapGestureOccur(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

// MARK: Keyboard Action
fileprivate extension ChatRoomViewController {
    @objc func keyboardWillShow(notification: Notification) {
        guard isScrolledToBottom else { return }
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveLinear
        ) {
            self.scrollToBottom(animated: false)
        }
    }
}

// MARK: ScrollView Delegate
extension ChatRoomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard collectionView.contentSize.height > collectionView.bounds.height else {
            isScrolledToBottom = true
            return
        }
        let bottomOffsetY = collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom
        isScrolledToBottom = collectionView.contentOffset.y >= bottomOffsetY - 30
    }
}

// MARK: UITextViewDelegate
extension ChatRoomViewController: UITextViewDelegate {
    private func scrollToBottom(animated: Bool) {
        guard collectionView.contentSize.height > collectionView.bounds.height else {
            return
        }
        let bottomOffset = CGPoint(
            x: 0,
            y: collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom
        )
        collectionView.setContentOffset(bottomOffset, animated: animated)
    }
