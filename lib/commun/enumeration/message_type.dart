enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif'),
  other('other');

  final String type;

  const MessageType(this.type);
}

extension ConvertMessage on String {
  MessageType toEnum() {
    switch (this) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'gif':
        return MessageType.gif;
      case 'other':
        return MessageType.other;
      default:
        return MessageType.text;
    }
  }
}
