/// Message grouping status
enum MessageGroupStatus {
  first,
  middle,
  last,
  single;

  bool get isFirst => this == MessageGroupStatus.first || this == MessageGroupStatus.single;
  bool get isLast => this == MessageGroupStatus.last || this == MessageGroupStatus.single;
}
