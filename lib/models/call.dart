class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialled;
  bool voice;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.channelId,
    required this.hasDialled,
    required this.voice,
  });

  // Named constructor to create a Call instance from a map
  factory Call.fromMap(Map<String, dynamic> callMap) {
    return Call(
      callerId: callMap["caller_id"],
      callerName: callMap["caller_name"],
      callerPic: callMap["caller_pic"],
      receiverId: callMap["receiver_id"],
      receiverName: callMap["receiver_name"],
      receiverPic: callMap["receiver_pic"],
      channelId: callMap["channel_id"],
      hasDialled: callMap["has_dialled"],
      voice: callMap['voice'],
    );
  }

  get sendername => null;

  // Method to convert a Call instance to a map
  Map<String, dynamic> toMap() {
    return {
      "caller_id": callerId,
      "caller_name": callerName,
      "caller_pic": callerPic,
      "receiver_id": receiverId,
      "receiver_name": receiverName,
      "receiver_pic": receiverPic,
      "channel_id": channelId,
      "has_dialled": hasDialled,
      'voice': voice,
    };
  }
}
