import SwiftUI

struct PostCell: View {
    var post: Post
    var body: some View {
        NavigationLink(
            destination: PostEditor(
                textString: post.editableText,
                postStatus: post.status
            )
        ) {
            HStack {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text(buildDateString(from: post.createdDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                PostStatusBadge(postStatus: post.status)
            }
        }
    }

    func buildDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: testPost)
    }
}