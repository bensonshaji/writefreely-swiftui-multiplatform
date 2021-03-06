import SwiftUI

struct PostTextEditingView: View {
    @ObservedObject var post: WFAPost
    @Binding var updatingTitleFromServer: Bool
    @Binding var updatingBodyFromServer: Bool
    @State private var isHovering: Bool = false
    @State private var appearance: PostAppearance = .serif
    private let bodyLineSpacingMultiplier: CGFloat = 0.5

    var body: some View {
        VStack {
            TextField("Title (optional)", text: $post.title)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 4)
                .font(.custom(appearance.rawValue, size: 26, relativeTo: .largeTitle))
                .onChange(of: post.title) { _ in
                    if post.status == PostStatus.published.rawValue && !updatingTitleFromServer {
                        post.status = PostStatus.edited.rawValue
                    }
                    if updatingTitleFromServer {
                        updatingTitleFromServer = false
                    }
                }
                .padding(4)
                .background(Color(NSColor.controlBackgroundColor))
                .padding(.bottom)
            ZStack(alignment: .topLeading) {
                if post.body.count == 0 {
                    Text("Write…")
                        .foregroundColor(Color(NSColor.placeholderTextColor))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .font(.custom(appearance.rawValue, size: 17, relativeTo: .body))
                }
                TextEditor(text: $post.body)
                    .font(.custom(appearance.rawValue, size: 17, relativeTo: .body))
                    .lineSpacing(17 * bodyLineSpacingMultiplier)
                    .opacity(post.body.count == 0 && !isHovering ? 0.0 : 1.0)
                    .onChange(of: post.body) { _ in
                        if post.status == PostStatus.published.rawValue && !updatingBodyFromServer {
                            post.status = PostStatus.edited.rawValue
                        }
                        if updatingBodyFromServer {
                            updatingBodyFromServer = false
                        }
                    }
                    .onHover(perform: { hovering in
                        self.isHovering = hovering
                    })
            }
            .padding(4)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .onAppear(perform: {
            switch post.appearance {
            case "sans":
                self.appearance = .sans
            case "wrap", "mono", "code":
                self.appearance = .mono
            default:
                self.appearance = .serif
            }
        })
    }
}
