//
//  MessengerView+Extensions.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/2/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import UIKit
import Fusuma


extension MessengerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return messages.count


    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        
        var cellIdentifier: String = ChatCell.identifier

        if (message.attachments != nil) && message.attachments?.count != 0 {
            if let file = message.attachments?.first {
                let mimeTypes = ["image/jpeg", "image/png", "image/gif", "image/tiff"]
                if mimeTypes.contains(file!.type) {
                    cellIdentifier = ImageCell.identifier
                } else {

                }
            }
            cellIdentifier = ImageCell.identifier

        }else if message.contentType == "videoCallRequest" || message.contentType == "videoCall" {
            cellIdentifier = VideoChatCell.identifier
        } else if message.user == nil {
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

        var h: CGFloat = 0
        var msg = ""
        if viewModel.isOnline {
          
            if let message = messengerData?.messages?.welcome {
                msg = message
                h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
            }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeader", for: indexPath) as? CollectionHeader
            headerView!.frame.size.height = h + 40
            headerView?.textView.text = msg
            if msg.count == 0 {
                headerView?.isHidden = true
            }
            return headerView!
        } else {
           
            if let message = messengerData?.messages?.away {
                msg = message
                h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
            }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionFooter", for: indexPath) as? CollectionFooter
            footerView!.frame.size.height = h + 40
            footerView?.textView.text = msg
            if msg.count == 0 {
                footerView?.isHidden = true
            }
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
      
    }
}


extension MessengerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = messages[indexPath.row]
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


extension MessengerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if ((textField.text != nil) && textField.text!.count > 0) {
            self.viewModel.insertMessage(customerId: customerId, visitorId: visitorId, message: textField.text, attachments: nil, conversationId: conversationId)
            textField.text = ""
        }
        
        return true
    }
}


extension MessengerView: FusumaDelegate {
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



extension MessengerView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        controller.dismiss(animated: true) {
           
            
            self.startUplaoder(image: UIImage(), filePath: url)
        }
    }
}

