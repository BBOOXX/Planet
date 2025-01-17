import SwiftUI


struct AppContentItemMenuView: View {
    @Binding var isShowingDeleteConfirmation: Bool
    @Binding var isSharingLink: Bool
    @Binding var sharedLink: String?

    var article: MyArticleModel

    var body: some View {
        VStack {
            Group {
                Button {
                    do {
                        try WriterStore.shared.editArticle(for: article)
                    }
                    catch {
                        PlanetStore.shared.alert(title: "Failed to launch writer")
                    }
                } label: {
                    Text("Edit Post")
                }

                Button {
                    PlanetStore.shared.selectedArticle = article
                    PlanetStore.shared.isShowingMyArticleSettings = true
                } label: {
                    Text("Settings")
                }

                Divider()
            }

            Group {
                Button {
                    if let url = article.browserURL {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(url.absoluteString, forType: .string)
                    }
                } label: {
                    Text("Copy Shareable Link")
                }

                Button {
                    if let url = article.browserURL {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    Text("Open Shareable Link in Browser")
                }

                Button {
                    if let url = article.localGatewayURL {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    Text("Test Post in Browser")
                }

                Divider()
            }

            Group {
                Button {
                    if let url = article.browserURL {
                        sharedLink = url.absoluteString
                        isSharingLink = true
                    }
                } label: {
                    Text("Share")
                }

                Divider()

                Button {
                    isShowingDeleteConfirmation = true
                } label: {
                    Text("Delete Post")
                }
            }
        }
    }
}
