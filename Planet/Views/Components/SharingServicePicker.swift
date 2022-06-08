import SwiftUI

struct SharingServicePicker: NSViewRepresentable {
    @Binding var isPresented: Bool
    var sharingItems: [Any] = []

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if isPresented {
            let picker = NSSharingServicePicker(items: sharingItems)
            picker.delegate = context.coordinator
            DispatchQueue.main.async {
                picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }

    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        let owner: SharingServicePicker

        init(owner: SharingServicePicker) {
            self.owner = owner
        }

        func sharingServicePicker(
            _ sharingServicePicker: NSSharingServicePicker,
            sharingServicesForItems items: [Any],
            proposedSharingServices proposedServices: [NSSharingService]
        ) -> [NSSharingService] {
            guard let image = NSImage(named: NSImage.networkName) else {
                return proposedServices
            }
            var share = proposedServices
            let copyService = NSSharingService(title: "Copy Planet IPNS", image: image, alternateImage: image) {
                if let ipns = items.first as? String {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(ipns, forType: .string)
                }
            }
            share.insert(copyService, at: 0)
            return share
        }

        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            sharingServicePicker.delegate = nil
            self.owner.isPresented = false
        }
    }
}
