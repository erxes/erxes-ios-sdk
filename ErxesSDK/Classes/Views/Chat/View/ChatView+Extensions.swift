//
//  ChatView+Extensions.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/21/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import UIKit
import Fusuma

extension ChatView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return chats.count
        
       
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = chats[indexPath.row]
        var cellIdentifier: String = ChatCell.identifier

        if let files = message.attachments, files.count > 0 {
            if let file = files.first {
                let mimeTypes = ["image/jpeg", "image/png", "image/gif", "image/tiff"]
                if mimeTypes.contains(file!.type) {
                    cellIdentifier = ImageCell.identifier
                } else {

                }
            }
            cellIdentifier = ImageCell.identifier
        } else if message.customerId != nil {
            cellIdentifier = ChatCell.identifier
        } else {
            cellIdentifier = OperatorChatCell.identifier
        }




        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        if let cell = cell as? BaseCells {
            cell.model = message
            if calculatedHeights.count != 0 {
                cell.width = calculatedWidths[indexPath.row]
                cell.height = calculatedHeights[indexPath.row]
            }
        }


        return cell

    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
        var h:CGFloat = 0
        var msg = ""
        if viewModel.isOnline {
            
            if let message = welcome {
                msg = message
                h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
            }
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeader", for: indexPath) as? CollectionHeader
            headerView!.frame.size.height = h + 40
            headerView?.textView.text = msg
            return headerView!
        }else {
            
            if let message = away {
                msg = message
                h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
            }
             let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionFooter", for: indexPath) as? CollectionFooter
            footerView!.frame.size.height = h + 40
            footerView?.textView.text = msg
            return footerView!
        }
        
        
        
    }
    
    func forceScrollToBottom() {
        if (self.collectionView.numberOfSections == 0) {
            return
        }

        //working but slow
        let items = self.collectionView.numberOfItems(inSection: 0)
        if (items > 0) {
            self.collectionView.layoutIfNeeded()
            let scrollRect = CGRect(x: 0, y: self.collectionView.contentSize.height - 1, width: 1.0, height: 1.0)
            self.collectionView.scrollRectToVisible(scrollRect, animated: true)
            collectionViewLoaded = true
        }
    }

    func scrollToBottom() {

        let lastItemIndex = (collectionView.numberOfItems(inSection: 0)) - 1
        let indexPath = IndexPath(item: lastItemIndex, section: 0)

        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionViewLoaded {
            self.headerView.scrollViewDidScroll(scrollView: scrollView)
            if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
                let rect = self.collectionView.frame
                let y = self.headerView.frame.size.height
                if rect.origin.y - y > 64 {
                    let newFrame = CGRect(x: 0, y: rect.origin.y - y, width: SCREEN_WIDTH, height: rect.height + y)
                    self.collectionView.frame = newFrame
                } else {
                    UIView.animate(withDuration: 0.1) {
                        self.collectionView.snp.remakeConstraints { (make) in
                            make.top.equalToSuperview().offset(64)
                            make.bottom.left.right.equalToSuperview()
                            make.left.right.equalToSuperview()
                        }
                        self.collectionView.layoutIfNeeded()
                    }
                }
            }
        }
    }
}


extension ChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = chats[indexPath.row]
        var height: CGFloat = 0
        var width: CGFloat = 0


            if indexPath.row < calculatedHeights.count {
                height = calculatedHeights[indexPath.row]
            } else {

                if let files = item.attachments, files.count > 0 {
                    height = 170
                    width = 150
                } else {
                    let size = BaseCells.getSizeOf(message: item)
                    height = size.height
                    width = size.width
                }

                calculatedWidths.append(width)
                calculatedHeights.append(height)

            }
        

        return CGSize(width: SCREEN_WIDTH, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}


extension ChatView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let mutation = InsertMessageMutation(integrationId: erxesIntegrationId, customerId: erxesCustomerId)
        if conversationId.count != 0 {
            mutation.conversationId = conversationId
        }
        mutation.message = textField.text
        self.viewModel.insertMessage(mutation: mutation)
        textField.text = ""
        return true
    }
}


extension ChatView: FusumaDelegate {
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {


        self.startUplaoder(image: image)


    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

    func fusumaCameraRollUnauthorized() {

    }


}
