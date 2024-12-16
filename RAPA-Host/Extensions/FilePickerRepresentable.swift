import SwiftUI
import UIKit
import PhotosUI

struct FilePicker: UIViewControllerRepresentable {
    var allowedTypes: [String]
    var allowsMultipleSelection: Bool
    var onPickedFiles: ([URL]) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
            
            let documentPickerAction = UIAlertAction(title: "Files", style: .default) { _ in
                let picker = UIDocumentPickerViewController(documentTypes: allowedTypes, in: .import)
                picker.delegate = context.coordinator
                picker.allowsMultipleSelection = allowsMultipleSelection
                viewController.present(picker, animated: true)
            }
            
            let photoPickerAction = UIAlertAction(title: "Photos", style: .default) { _ in
                var config = PHPickerConfiguration()
                config.filter = .images
                config.selectionLimit = allowsMultipleSelection ? 0 : 1
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = context.coordinator
                viewController.present(picker, animated: true)
            }
            
            alert.addAction(documentPickerAction)
            alert.addAction(photoPickerAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            viewController.present(alert, animated: true)
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
        var parent: FilePicker
        
        init(_ parent: FilePicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onPickedFiles(urls)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onPickedFiles([])
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            let urls = results.compactMap { result -> URL? in
                guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return nil }
                var url: URL?
                let semaphore = DispatchSemaphore(value: 0)
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { (fileURL, error) in
                    url = fileURL
                    semaphore.signal()
                }
                semaphore.wait()
                return url
            }
            parent.onPickedFiles(urls)
        }
    }
}
