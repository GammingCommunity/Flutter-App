class GroupChatService{
  static textMessage(String roomID,String currentID,String text){
    return [
          {
            "groupID": roomID,
          },
          {
            "type": "text",
            "id": currentID,
            "text": {
              "content":text,
              "height":0,
              "width":0
            },
          }
        ];
  }
  static mediaMessage(String roomID,String currentID,String url,int height,int width){
    return [
          {
            "groupID": roomID,
          },
          {
            "type": "media",
            "id": currentID,
            "text": {
              "content":url,
              "height":height,
              "width":width
            },
          }
        ];
  }
  
}