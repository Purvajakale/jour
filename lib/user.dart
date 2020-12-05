class userData {
  final String uid;
  userData({this.uid});
}

class userStream {
  final String uid;
  final String work;
  final String name;
  final String description;
  final int importance;

  userStream(
      {this.uid, this.work, this.name, this.description, this.importance});
}
