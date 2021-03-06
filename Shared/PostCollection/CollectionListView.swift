import SwiftUI

struct CollectionListView: View {
    @EnvironmentObject var model: WriteFreelyModel

    @FetchRequest(
        entity: WFACollection.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WFACollection.title, ascending: true)]
    ) var collections: FetchedResults<WFACollection>

    var body: some View {
        List {
            if model.account.isLoggedIn {
                NavigationLink(destination: PostListView(selectedCollection: nil, showAllPosts: true)) {
                    Text("All Posts")
                }
                NavigationLink(destination: PostListView(selectedCollection: nil, showAllPosts: false)) {
                    Text(model.account.server == "https://write.as" ? "Anonymous" : "Drafts")
                }
                Section(header: Text("Your Blogs")) {
                    ForEach(collections, id: \.alias) { collection in
                        NavigationLink(
                            destination: PostListView(selectedCollection: collection, showAllPosts: false)
                        ) {
                            Text(collection.title)
                        }
                    }
                }
            } else {
                NavigationLink(destination: PostListView(selectedCollection: nil, showAllPosts: false)) {
                    Text("Drafts")
                }
            }
        }
        .navigationTitle(
            model.account.isLoggedIn ? "\(URL(string: model.account.server)?.host ?? "WriteFreely")" : "WriteFreely"
        )
        .listStyle(SidebarListStyle())
    }
}

struct CollectionListView_LoggedOutPreviews: PreviewProvider {
    static var previews: some View {
        let context = LocalStorageManager.persistentContainer.viewContext
        let model = WriteFreelyModel()

        return CollectionListView()
            .environment(\.managedObjectContext, context)
            .environmentObject(model)
    }
}
