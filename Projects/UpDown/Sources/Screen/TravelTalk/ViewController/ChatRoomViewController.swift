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
    private let chatOtherCell = Bundle.main.loadNibNamed(ChatOtherCell.id, owner: nil, options: nil)?.first as! ChatOtherCell
    private let chatMeCell = Bundle.main.loadNibNamed(ChatMeCell.id, owner: nil, options: nil)?.first as! ChatMeCell
    
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
        messageInputView.delegate = self
        let constraint = view.keyboardLayoutGuide.topAnchor
            .constraint(
                equalToSystemSpacingBelow: inputContainerView.bottomAnchor,
                multiplier: 1.0
            )
        view.keyboardLayoutGuide.setConstraints(
            [constraint],
            activeWhenAwayFrom: .top
        )
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
    
    private func setCusorPositionIfPlaceHolder(_ textView: UITextView) {
        if let inputView = textView as? MessageInputView, inputView.focusState == .placeHolder {
            inputView.selectedTextRange = inputView.textRange(from: inputView.beginningOfDocument, to: inputView.beginningOfDocument)
        }
    }
    
    private func updateInputViewHeightIfNeeded(_ inputView: MessageInputView) -> Bool {
        let newInputViewHeight = inputView.sizeThatFitViewHeight()
        if newInputViewHeight != inputViewHeightAnchor.constant {
            inputViewHeightAnchor.constant = newInputViewHeight
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            return true
        } else {
            return false
        }
    }
    
    private func messageSendButtonUpdateIfNeeded() {
        let inputText = messageInputView.text.removeAllWhitespace()
        let focus = messageInputView.focusState
        if focus == .placeHolder {
            sendButton.isEnabled = false
            return
        }
        
        if inputText.isEmpty {
            sendButton.isEnabled = false
            return
        }
        sendButton.isEnabled = true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setCusorPositionIfPlaceHolder(textView)
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        setCusorPositionIfPlaceHolder(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let inputView = textView as? MessageInputView else {
            return
        }
        
        let wasBottom = isScrolledToBottom
        
        inputView.setToPlaceHolderIfNeeded()
        
        let isChange = updateInputViewHeightIfNeeded(inputView)
        
        if isChange && wasBottom {
             scrollToBottom(animated: true)
        }
        
        messageSendButtonUpdateIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let inputView = textView as? MessageInputView else {
            return false
        }
        inputView.setToFocusIfNeeded(text: text)
        return true
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ChatRoomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = sectionModels[indexPath.section].items[indexPath.row]
        if model.chat.user == ChatList.me {
            chatMeCell.configure(info: model)
            chatMeCell.layoutIfNeeded()
            let (height, isTruncated) = chatMeCell.layoutHeightFitting()
            
            let size = CGSize(
                width: windowWidth,
                height: height
            )
            sectionModels[indexPath.section].items[indexPath.row].isTruncated = isTruncated
            return size
        } else {
            chatOtherCell.configure(info: model)
            chatOtherCell.layoutIfNeeded()
            let (height, isTruncated) = chatOtherCell.layoutHeightFitting()
            let size = CGSize(
                width: windowWidth,
                height: height
            )
            sectionModels[indexPath.section].items[indexPath.row].isTruncated = isTruncated
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: windowWidth, height: 30)
    }
}

// MARK: UICollectionViewDataSource
extension ChatRoomViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionModels[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionDateHeaderView.id, for: indexPath) as? SectionDateHeaderView else {
                fatalError("헤더 뷰를 가져올 수 없습니다.")
            }
            let sectionModel = sectionModels[indexPath.section]
            header.configure(with: sectionModel.date)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sectionModels[indexPath.section].items[indexPath.row]
        if model.chat.user == ChatList.me {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMeCell.id, for: indexPath) as? ChatMeCell else {
                return UICollectionViewCell()
            }
            cell.configure(info: model)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatOtherCell.id, for: indexPath) as? ChatOtherCell else {
                return UICollectionViewCell()
            }
            cell.configure(info: model)
            return cell
        }
    }
}

