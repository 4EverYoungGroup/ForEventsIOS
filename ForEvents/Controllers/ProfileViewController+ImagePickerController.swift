//
//  ProfileViewController+ImagePickerController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 13/11/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit
import Photos

//MARK: - UIImagePickerControllerDelegate
extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func createPhotosAlert() {
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Elegir imagen", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Atención", message: "Su dispositivo no dispone de cámara", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userButton.setBackgroundImage(editedImage, for: .normal)
            UserDefaults.standard.setImage(image: editedImage, forKey: "userPhoto")
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- PHOTO LIBRARY ACCESS CHECK
    func photoLibraryAvailabilityCheck() -> Bool
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            return true
        }
        return false
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            self.createPhotosAlert()
        }
        else
        {
            alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
        }
    }
    
    //MARK:- CAMERA & GALLERY NOT ALLOWING ACCESS - ALERT
    func alertToEncourageCameraAccessWhenApplicationStarts()
    {
        //Camera not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: "Camara no disponible", message: "Verifique si está desconectada o en uso por otra aplicación", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ajustes", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) //(url as URL)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        self.present(cameraUnavailableAlertController, animated: true, completion: nil)
    }
    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
    {
        //Photo Library not available - Alert
        let photoLibraryUnavailableAlertController = UIAlertController (title: "Librería de fotos no disponible", message: "Verifique si la configuración del dispositivo no permite el acceso a la biblioteca de fotos", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ajustes", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        photoLibraryUnavailableAlertController .addAction(settingsAction)
        photoLibraryUnavailableAlertController .addAction(cancelAction)
        self.present(photoLibraryUnavailableAlertController, animated: true, completion: nil)
    }
}
