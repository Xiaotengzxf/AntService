// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file Message.proto

import Foundation
import ProtocolBuffers


public func == (lhs: Immessage, rhs: Immessage) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasSenderId == rhs.hasSenderId) && (!lhs.hasSenderId || lhs.senderId == rhs.senderId)
  fieldCheck = fieldCheck && (lhs.hasMessageType == rhs.hasMessageType) && (!lhs.hasMessageType || lhs.messageType == rhs.messageType)
  fieldCheck = fieldCheck && (lhs.hasMessageState == rhs.hasMessageState) && (!lhs.hasMessageState || lhs.messageState == rhs.messageState)
  fieldCheck = fieldCheck && (lhs.hasReceiveId == rhs.hasReceiveId) && (!lhs.hasReceiveId || lhs.receiveId == rhs.receiveId)
  fieldCheck = fieldCheck && (lhs.hasContent == rhs.hasContent) && (!lhs.hasContent || lhs.content == rhs.content)
  fieldCheck = fieldCheck && (lhs.hasSendTime == rhs.hasSendTime) && (!lhs.hasSendTime || lhs.sendTime == rhs.sendTime)
  fieldCheck = fieldCheck && (lhs.hasMsgId == rhs.hasMsgId) && (!lhs.hasMsgId || lhs.msgId == rhs.msgId)
  fieldCheck = fieldCheck && (lhs.hasSendCount == rhs.hasSendCount) && (!lhs.hasSendCount || lhs.sendCount == rhs.sendCount)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public struct Message_Root {
  public static var sharedInstance : Message_Root {
   struct Static {
       static let instance : Message_Root = Message_Root()
   }
   return Static.instance
  }
  public var extensionRegistry:ExtensionRegistry

  init() {
    extensionRegistry = ExtensionRegistry()
    registerAllExtensions(extensionRegistry)
  }
  public func registerAllExtensions(registry:ExtensionRegistry) {
  }
}



//Enum type declaration start 

public enum MessageType:Int32, CustomDebugStringConvertible, CustomStringConvertible {
  //登录
  case Login = 1

  //推送消息
  case Send = 2

  //回复
  case Reply = 3

  //心跳
  case Ping = 4

  //退出
  case Exit = 5

  //登录相应 暂时未用到
  case ReplyLogin = 6

  //退出相应信息 暂时未用到
  case ReplyExit = 7

  //单点登录
  case Squeeze = 8

  public var debugDescription:String { return getDescription() }
  public var description:String { return getDescription() }
  private func getDescription() -> String { 
      switch self {
          case .Login: return ".Login"
          case .Send: return ".Send"
          case .Reply: return ".Reply"
          case .Ping: return ".Ping"
          case .Exit: return ".Exit"
          case .ReplyLogin: return ".ReplyLogin"
          case .ReplyExit: return ".ReplyExit"
          case .Squeeze: return ".Squeeze"
      }
  }
}

//Enum type declaration end 



//Enum type declaration start 

public enum MessageState:Int32, CustomDebugStringConvertible, CustomStringConvertible {
  //等待发送
  case Waitsend = 1

  //发送中
  case Sending = 2

  //发送成功
  case Success = 3

  //发送失败
  case Failure = 4

  public var debugDescription:String { return getDescription() }
  public var description:String { return getDescription() }
  private func getDescription() -> String { 
      switch self {
          case .Waitsend: return ".Waitsend"
          case .Sending: return ".Sending"
          case .Success: return ".Success"
          case .Failure: return ".Failure"
      }
  }
}

//Enum type declaration end 

//登录消息
final public class Immessage : GeneratedMessage, GeneratedMessageProtocol {
  //发送人Id
  public private(set) var senderId:String = ""

  public private(set) var hasSenderId:Bool = false
  public private(set) var messageType:MessageType = MessageType.Login
  public private(set) var hasMessageType:Bool = false
  public private(set) var messageState:MessageState = MessageState.Waitsend
  public private(set) var hasMessageState:Bool = false
  //接收人ID
  public private(set) var receiveId:String = ""

  public private(set) var hasReceiveId:Bool = false
  //消息内容
  public private(set) var content:String = ""

  public private(set) var hasContent:Bool = false
  //发送时间
  public private(set) var sendTime:UInt64 = UInt64(0)

  public private(set) var hasSendTime:Bool = false
  //消息ID
  public private(set) var msgId:UInt64 = UInt64(0)

  public private(set) var hasMsgId:Bool = false
  //发送次数
  public private(set) var sendCount:Int32 = Int32(0)

  public private(set) var hasSendCount:Bool = false
  required public init() {
       super.init()
  }
  override public func isInitialized() -> Bool {
   return true
  }
  override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
    if hasSenderId {
      try output.writeString(1, value:senderId)
    }
    if hasMessageType {
      try output.writeEnum(2, value:messageType.rawValue)
    }
    if hasMessageState {
      try output.writeEnum(3, value:messageState.rawValue)
    }
    if hasReceiveId {
      try output.writeString(4, value:receiveId)
    }
    if hasContent {
      try output.writeString(5, value:content)
    }
    if hasSendTime {
      try output.writeFixed64(6, value:sendTime)
    }
    if hasMsgId {
      try output.writeFixed64(7, value:msgId)
    }
    if hasSendCount {
      try output.writeInt32(8, value:sendCount)
    }
    try unknownFields.writeToCodedOutputStream(output)
  }
  override public func serializedSize() -> Int32 {
    var serialize_size:Int32 = memoizedSerializedSize
    if serialize_size != -1 {
     return serialize_size
    }

    serialize_size = 0
    if hasSenderId {
      serialize_size += senderId.computeStringSize(1)
    }
    if (hasMessageType) {
      serialize_size += messageType.rawValue.computeEnumSize(2)
    }
    if (hasMessageState) {
      serialize_size += messageState.rawValue.computeEnumSize(3)
    }
    if hasReceiveId {
      serialize_size += receiveId.computeStringSize(4)
    }
    if hasContent {
      serialize_size += content.computeStringSize(5)
    }
    if hasSendTime {
      serialize_size += sendTime.computeFixed64Size(6)
    }
    if hasMsgId {
      serialize_size += msgId.computeFixed64Size(7)
    }
    if hasSendCount {
      serialize_size += sendCount.computeInt32Size(8)
    }
    serialize_size += unknownFields.serializedSize()
    memoizedSerializedSize = serialize_size
    return serialize_size
  }
  public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Immessage> {
    var mergedArray = Array<Immessage>()
    while let value = try parseFromDelimitedFromInputStream(input) {
      mergedArray += [value]
    }
    return mergedArray
  }
  public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Immessage? {
    return try Immessage.Builder().mergeDelimitedFromInputStream(input)?.build()
  }
  public class func parseFromData(data:NSData) throws -> Immessage {
    return try Immessage.Builder().mergeFromData(data, extensionRegistry:Message_Root.sharedInstance.extensionRegistry).build()
  }
  public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Immessage {
    return try Immessage.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromInputStream(input:NSInputStream) throws -> Immessage {
    return try Immessage.Builder().mergeFromInputStream(input).build()
  }
  public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Immessage {
    return try Immessage.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Immessage {
    return try Immessage.Builder().mergeFromCodedInputStream(input).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Immessage {
    return try Immessage.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func getBuilder() -> Immessage.Builder {
    return Immessage.classBuilder() as! Immessage.Builder
  }
  public func getBuilder() -> Immessage.Builder {
    return classBuilder() as! Immessage.Builder
  }
  public override class func classBuilder() -> MessageBuilder {
    return Immessage.Builder()
  }
  public override func classBuilder() -> MessageBuilder {
    return Immessage.Builder()
  }
  public func toBuilder() throws -> Immessage.Builder {
    return try Immessage.builderWithPrototype(self)
  }
  public class func builderWithPrototype(prototype:Immessage) throws -> Immessage.Builder {
    return try Immessage.Builder().mergeFrom(prototype)
  }
  override public func getDescription(indent:String) throws -> String {
    var output:String = ""
    if hasSenderId {
      output += "\(indent) senderId: \(senderId) \n"
    }
    if (hasMessageType) {
      output += "\(indent) messageType: \(messageType.description)\n"
    }
    if (hasMessageState) {
      output += "\(indent) messageState: \(messageState.description)\n"
    }
    if hasReceiveId {
      output += "\(indent) receiveId: \(receiveId) \n"
    }
    if hasContent {
      output += "\(indent) content: \(content) \n"
    }
    if hasSendTime {
      output += "\(indent) sendTime: \(sendTime) \n"
    }
    if hasMsgId {
      output += "\(indent) msgId: \(msgId) \n"
    }
    if hasSendCount {
      output += "\(indent) sendCount: \(sendCount) \n"
    }
    output += unknownFields.getDescription(indent)
    return output
  }
  override public var hashValue:Int {
      get {
          var hashCode:Int = 7
          if hasSenderId {
             hashCode = (hashCode &* 31) &+ senderId.hashValue
          }
          if hasMessageType {
             hashCode = (hashCode &* 31) &+ Int(messageType.rawValue)
          }
          if hasMessageState {
             hashCode = (hashCode &* 31) &+ Int(messageState.rawValue)
          }
          if hasReceiveId {
             hashCode = (hashCode &* 31) &+ receiveId.hashValue
          }
          if hasContent {
             hashCode = (hashCode &* 31) &+ content.hashValue
          }
          if hasSendTime {
             hashCode = (hashCode &* 31) &+ sendTime.hashValue
          }
          if hasMsgId {
             hashCode = (hashCode &* 31) &+ msgId.hashValue
          }
          if hasSendCount {
             hashCode = (hashCode &* 31) &+ sendCount.hashValue
          }
          hashCode = (hashCode &* 31) &+  unknownFields.hashValue
          return hashCode
      }
  }


  //Meta information declaration start

  override public class func className() -> String {
      return "Immessage"
  }
  override public func className() -> String {
      return "Immessage"
  }
  override public func classMetaType() -> GeneratedMessage.Type {
      return Immessage.self
  }
  //Meta information declaration end

  final public class Builder : GeneratedMessageBuilder {
    private var builderResult:Immessage = Immessage()
    public func getMessage() -> Immessage {
        return builderResult
    }

    required override public init () {
       super.init()
    }
    public var hasSenderId:Bool {
         get {
              return builderResult.hasSenderId
         }
    }
    public var senderId:String {
         get {
              return builderResult.senderId
         }
         set (value) {
             builderResult.hasSenderId = true
             builderResult.senderId = value
         }
    }
    public func setSenderId(value:String) -> Immessage.Builder {
      self.senderId = value
      return self
    }
    public func clearSenderId() -> Immessage.Builder{
         builderResult.hasSenderId = false
         builderResult.senderId = ""
         return self
    }
      public var hasMessageType:Bool{
          get {
              return builderResult.hasMessageType
          }
      }
      public var messageType:MessageType {
          get {
              return builderResult.messageType
          }
          set (value) {
              builderResult.hasMessageType = true
              builderResult.messageType = value
          }
      }
      public func setMessageType(value:MessageType) -> Immessage.Builder {
        self.messageType = value
        return self
      }
      public func clearMessageType() -> Immessage.Builder {
         builderResult.hasMessageType = false
         builderResult.messageType = .Login
         return self
      }
      public var hasMessageState:Bool{
          get {
              return builderResult.hasMessageState
          }
      }
      public var messageState:MessageState {
          get {
              return builderResult.messageState
          }
          set (value) {
              builderResult.hasMessageState = true
              builderResult.messageState = value
          }
      }
      public func setMessageState(value:MessageState) -> Immessage.Builder {
        self.messageState = value
        return self
      }
      public func clearMessageState() -> Immessage.Builder {
         builderResult.hasMessageState = false
         builderResult.messageState = .Waitsend
         return self
      }
    public var hasReceiveId:Bool {
         get {
              return builderResult.hasReceiveId
         }
    }
    public var receiveId:String {
         get {
              return builderResult.receiveId
         }
         set (value) {
             builderResult.hasReceiveId = true
             builderResult.receiveId = value
         }
    }
    public func setReceiveId(value:String) -> Immessage.Builder {
      self.receiveId = value
      return self
    }
    public func clearReceiveId() -> Immessage.Builder{
         builderResult.hasReceiveId = false
         builderResult.receiveId = ""
         return self
    }
    public var hasContent:Bool {
         get {
              return builderResult.hasContent
         }
    }
    public var content:String {
         get {
              return builderResult.content
         }
         set (value) {
             builderResult.hasContent = true
             builderResult.content = value
         }
    }
    public func setContent(value:String) -> Immessage.Builder {
      self.content = value
      return self
    }
    public func clearContent() -> Immessage.Builder{
         builderResult.hasContent = false
         builderResult.content = ""
         return self
    }
    public var hasSendTime:Bool {
         get {
              return builderResult.hasSendTime
         }
    }
    public var sendTime:UInt64 {
         get {
              return builderResult.sendTime
         }
         set (value) {
             builderResult.hasSendTime = true
             builderResult.sendTime = value
         }
    }
    public func setSendTime(value:UInt64) -> Immessage.Builder {
      self.sendTime = value
      return self
    }
    public func clearSendTime() -> Immessage.Builder{
         builderResult.hasSendTime = false
         builderResult.sendTime = UInt64(0)
         return self
    }
    public var hasMsgId:Bool {
         get {
              return builderResult.hasMsgId
         }
    }
    public var msgId:UInt64 {
         get {
              return builderResult.msgId
         }
         set (value) {
             builderResult.hasMsgId = true
             builderResult.msgId = value
         }
    }
    public func setMsgId(value:UInt64) -> Immessage.Builder {
      self.msgId = value
      return self
    }
    public func clearMsgId() -> Immessage.Builder{
         builderResult.hasMsgId = false
         builderResult.msgId = UInt64(0)
         return self
    }
    public var hasSendCount:Bool {
         get {
              return builderResult.hasSendCount
         }
    }
    public var sendCount:Int32 {
         get {
              return builderResult.sendCount
         }
         set (value) {
             builderResult.hasSendCount = true
             builderResult.sendCount = value
         }
    }
    public func setSendCount(value:Int32) -> Immessage.Builder {
      self.sendCount = value
      return self
    }
    public func clearSendCount() -> Immessage.Builder{
         builderResult.hasSendCount = false
         builderResult.sendCount = Int32(0)
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Immessage.Builder {
      builderResult = Immessage()
      return self
    }
    public override func clone() throws -> Immessage.Builder {
      return try Immessage.builderWithPrototype(builderResult)
    }
    public override func build() throws -> Immessage {
         try checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Immessage {
      let returnMe:Immessage = builderResult
      return returnMe
    }
    public func mergeFrom(other:Immessage) throws -> Immessage.Builder {
      if other == Immessage() {
       return self
      }
      if other.hasSenderId {
           senderId = other.senderId
      }
      if other.hasMessageType {
           messageType = other.messageType
      }
      if other.hasMessageState {
           messageState = other.messageState
      }
      if other.hasReceiveId {
           receiveId = other.receiveId
      }
      if other.hasContent {
           content = other.content
      }
      if other.hasSendTime {
           sendTime = other.sendTime
      }
      if other.hasMsgId {
           msgId = other.msgId
      }
      if other.hasSendCount {
           sendCount = other.sendCount
      }
      try mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Immessage.Builder {
         return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Immessage.Builder {
      let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        let protobufTag = try input.readTag()
        switch protobufTag {
        case 0: 
          self.unknownFields = try unknownFieldsBuilder.build()
          return self

        case 10 :
          senderId = try input.readString()

        case 16 :
          let valueIntmessageType = try input.readEnum()
          if let enumsmessageType = MessageType(rawValue:valueIntmessageType){
               messageType = enumsmessageType
          } else {
               try unknownFieldsBuilder.mergeVarintField(2, value:Int64(valueIntmessageType))
          }

        case 24 :
          let valueIntmessageState = try input.readEnum()
          if let enumsmessageState = MessageState(rawValue:valueIntmessageState){
               messageState = enumsmessageState
          } else {
               try unknownFieldsBuilder.mergeVarintField(3, value:Int64(valueIntmessageState))
          }

        case 34 :
          receiveId = try input.readString()

        case 42 :
          content = try input.readString()

        case 49 :
          sendTime = try input.readFixed64()

        case 57 :
          msgId = try input.readFixed64()

        case 64 :
          sendCount = try input.readInt32()

        default:
          if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:protobufTag))) {
             unknownFields = try unknownFieldsBuilder.build()
             return self
          }
        }
      }
    }
  }

}


// @@protoc_insertion_point(global_scope)
