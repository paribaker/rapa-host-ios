import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    @Binding var isLoading: Bool
    
    class Coordinator: NSObject {
        var parent: PDFKitView
        var pdfView: PDFView?
        
        init(parent: PDFKitView) {
            self.parent = parent
        }
        
        func loadPDF() {
            DispatchQueue.global(qos: .userInitiated).async {
                guard let document = PDFDocument(url: self.parent.url) else {
                    DispatchQueue.main.async {
                        self.parent.isLoading = false
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.pdfView?.document = document
                    self.parent.isLoading = false
                }
            }
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> UIView {
        let containerView = UIView()
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        context.coordinator.pdfView = pdfView
        context.coordinator.loadPDF()
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitView>) {
        // No update needed
    }
}

#Preview {
    PDFKitView(url: URL(string: "https://www.example.com/sample.pdf")!, isLoading: .constant(true))
}
