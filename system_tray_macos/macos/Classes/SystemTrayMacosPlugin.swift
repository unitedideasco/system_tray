import Cocoa
import FlutterMacOS

public class SystemTrayMacosPlugin: NSObject, FlutterPlugin {
    var statusBarItem : NSStatusItem!
    
    private let channel: FlutterMethodChannel
    private let registrar: FlutterPluginRegistrar
    private let statusBarItemController : StatusBarItemController;

    required init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
        self.channel = channel
        self.registrar = registrar
        self.statusBarItemController = StatusBarItemController(channel: channel)
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "unitedideas.co/system_tray",
            binaryMessenger: registrar.messenger
        )
        let instance = SystemTrayMacosPlugin(channel: channel, registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }


    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "setIcon":
                let arguments = call.arguments as! [String: Any]
            
                let iconFlutterBytes = arguments["iconBytes"] as! FlutterStandardTypedData
                let iconFlutterBytesLength = arguments["iconBytesLength"] as! NSNumber

                let iconBytes = [UInt8](iconFlutterBytes.data)
                let iconBytesLength = iconFlutterBytesLength.intValue;

                result(setIcon(iconBytes, iconBytesLength))
            case "setMenu":

                let arguments = call.arguments as! [String: Any]
                let trayActions = arguments["trayActions"] as! Array<[String: String]>
            
                result(setMenu(trayActions))
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    private func setIcon(_ iconBytes: [UInt8], _ iconBytesLength: Int) -> Bool? {
        return statusBarItemController.setIcon(iconBytes, iconBytesLength)
    }
    
    private func setMenu(_ trayActions: Array<[String: String]>) -> Bool? {
        return statusBarItemController.setMenu(trayActions)
    }

}



class StatusBarItemController: NSObject {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private let channel: FlutterMethodChannel


    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func setIcon(_ iconBytes: [UInt8], _ iconBytesLength: Int) -> Bool {

        let data = NSData(bytes: iconBytes, length: iconBytesLength)
        let image = NSImage(data: Data(referencing: data));
                
        let width = image!.size.width * 18 / image!.size.height
            
        let iconSize = NSMakeSize(width, 18);
        image?.size = iconSize
        
        statusBarItem.button?.image = image
        return true
    }
    
    
    public func setMenu(_ trayActions: Array<[String: String]>) -> Bool {
        let menu = NSMenu()

        for trayAction in trayActions {
            let label = trayAction["label"]! as String
            let name = trayAction["name"]! as String

            
            let menuItem = NSMenuItem(
                title: label,
                action: #selector(StatusBarItemController.callback(_:)),
                keyEquivalent: ""
            )
            
            menuItem.setName(name)
            menuItem.target = self
            menu.addItem(menuItem);
        }
    
        menu.autoenablesItems = false
        
        statusBarItem.menu = menu;
        statusBarItem.target = self
        return true
    }
    

    @objc func callback(_ sender : NSMenuItem) {
        let name = sender.name;
        channel.invokeMethod( "menu.handleMenuClick", arguments: ["name": name as String] )
    }
}

struct AssociatedKeys {
    static var name: String = ""
}

extension NSMenuItem {

    private(set) var name: String {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.name) as? String else {
                return ""
            }
            return value
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.name, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func setName(_ name: String) {
        self.name = name;
    }
}


