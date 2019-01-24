//
//  Device.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Device:Object, Decodable {
    @objc dynamic var name:String=""
    @objc dynamic var brand:String=""
    //Main specs
    @objc dynamic var cpu:String=""
    @objc dynamic var screenResolution:String=""
    @objc dynamic var ram:String=""
    @objc dynamic var batteryShort:String=""
    @objc dynamic var rearCamera:String=""
    @objc dynamic var frontCamera:String=""
    //TODO var internalMemory:Double=0
    //Additional specs
    //--Release
    @objc dynamic var announcedDate:String=""
    @objc dynamic var releaseStatus:String=""
    //--Physical
    @objc dynamic var screenSize:String=""
    @objc dynamic var dimensions:String=""
    @objc dynamic var weight:String=""
    //--Hardware
    @objc dynamic var gpu:String=""
    @objc dynamic var chipset:String=""
    @objc dynamic var headphoneJack:String=""
    @objc dynamic var usb:String=""
    @objc dynamic var simType:String=""
    @objc dynamic var cardSlot:String=""
    //--Software
    @objc dynamic var os:String=""
    
    convenience init(name: String, brand:String) {
        self.init()
        self.name = name
        self.brand = brand
    }
    
   override var description: String {
        return "Device: \(name), Brand: \(brand)"
    }
    
    //Codable
    //--Codable constructor (can't be put in extension)
    required init(from decoder: Decoder) throws {
        super.init()
        let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
        
        self.name = (try? valueContainer.decode(String.self, forKey: CodingKeys.name)) ?? ""
        self.brand = (try? valueContainer.decode(String.self, forKey: CodingKeys.brand)) ?? ""
        var cpuValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.cpu) else {return ""}
            let regex = NSRegularExpression("[0-9]*\\.[0-9]* GHz")
            return regex.matches(stringValue)
        }
        self.cpu = cpuValue
        var screenResolutionValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.screenResolution) else {return ""}
            let regex = NSRegularExpression("[0-9]* x [0-9]*")
            return regex.matches(stringValue)
        }
        self.screenResolution = screenResolutionValue
        var ramValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.internalProp) else {return ""}
            let regex = NSRegularExpression("[0-9]* GB RAM")
            return regex.matches(stringValue).replacingOccurrences(of: "RAM", with: "")
            }
        self.ram = ramValue
        var batteryValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.batteryShort) else {return ""}
            let regex = NSRegularExpression("[0-9]* mAh")
            return regex.matches(stringValue)
        }
        self.batteryShort = batteryValue
        var primaryCameraValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.rearCamera) else {return ""}
            let regex = NSRegularExpression("[0-9]* MP")
            return regex.matches(stringValue)
        }
        self.rearCamera = primaryCameraValue
        var secondaryCameraValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.frontCamera) else {return ""}
            let regex = NSRegularExpression("[0-9]* MP")
            return regex.matches(stringValue)
        }
        self.frontCamera = secondaryCameraValue
        //Additional Specs
        //--Release
        self.announcedDate = (try? valueContainer.decode(String.self, forKey: CodingKeys.announcedDate)) ?? ""
        self.releaseStatus = (try? valueContainer.decode(String.self, forKey: CodingKeys.releaseStatus)) ?? ""
        //--Physical
        self.screenSize = (try? valueContainer.decode(String.self, forKey: CodingKeys.screenSize)) ?? ""
        self.dimensions = (try? valueContainer.decode(String.self, forKey: CodingKeys.dimensions)) ?? ""
        self.weight = (try? valueContainer.decode(String.self, forKey: CodingKeys.weight)) ?? ""
        //--Hardware
        self.gpu = (try? valueContainer.decode(String.self, forKey: CodingKeys.gpu)) ?? ""
        self.chipset = (try? valueContainer.decode(String.self, forKey: CodingKeys.chipset)) ?? ""
        var headphoneJackValue:String{
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.headphoneJack) else {return ""}
            switch stringValue.lowercased() {
            case "yes":
                return "true"
            case "no":
                return "false"
            default:
                return ""
            }
        }
        self.headphoneJack = headphoneJackValue
        self.usb = (try? valueContainer.decode(String.self, forKey: CodingKeys.usb)) ?? ""
        self.simType = (try? valueContainer.decode(String.self, forKey: CodingKeys.simType)) ?? ""
        self.cardSlot = (try? valueContainer.decode(String.self, forKey: CodingKeys.cardSlot)) ?? ""
        //--Software
        self.os = (try? valueContainer.decode(String.self, forKey: CodingKeys.os)) ?? ""
    }
    
    //--Json coding keys and enum value for other properties
    enum CodingKeys: String, CodingKey {
        case name = "DeviceName"
        case brand = "Brand"
        case cpu
        case screenResolution = "resolution"
        case internalProp = "internal"
        case batteryShort = "battery_c"
        case rearCamera = "primary_"
        case frontCamera = "secondary"
        //Additional specs
        //--Release
        case announcedDate = "announced"
        case releaseStatus = "status"
        //--Physical
        case screenSize = "size"
        case dimensions
        case weight
        //--Hardware
        case gpu
        case chipset
        case headphoneJack = "_3_5mm_jack_"
        case usb
        case simType = "sim"
        case cardSlot = "card_slot"
        //--Software
        case os
    }
    //**************
    
    
    //Realm constructors (can't be put in extension)
    required init() {
        super.init()
    }
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    //**************
    
}

//Main Specs
extension Device{
 
    //Not using coding keys, so we can split fields into multiple ones (e.g. batteryShort and the full battery text)
    //Also the images are named after these enum values
    enum MainSpecIdentifier:String{
        case cpu
        case screenResolution
        case ram
        case battery
        case rearCamera
        case frontCamera
    }
    //Define main specs with enum value so caller can handle it accordingly
    //Only not-empty values are added
    func mainSpecs() -> [MainDeviceSpec]{
        var result:[MainDeviceSpec] = []
        if !cpu.isEmpty {result.append(MainDeviceSpec(identifier: .cpu, name: NSLocalizedString("CPU", comment: ""), value:cpu))}
        if !screenResolution.isEmpty {result.append(MainDeviceSpec(identifier: .screenResolution, name: NSLocalizedString("Resolution", comment: ""), value:screenResolution))}
        if !ram.isEmpty {result.append(MainDeviceSpec(identifier: .ram, name: NSLocalizedString("RAM", comment: ""), value: ram))}
        if !batteryShort.isEmpty {result.append(MainDeviceSpec(identifier: .battery, name: NSLocalizedString("Battery", comment: ""), value: batteryShort))}
        if !rearCamera.isEmpty {result.append(MainDeviceSpec(identifier: .rearCamera, name: NSLocalizedString("Rear camera", comment: ""), value: rearCamera))}
        if !frontCamera.isEmpty {result.append(MainDeviceSpec(identifier: .frontCamera, name: NSLocalizedString("Front camera", comment: ""), value: frontCamera))}
        return result
    }
    
    func additionalSpecCategoriesAndValues() -> [DeviceSpecCategory]{
        var categories : [DeviceSpecCategory] = []
        //Release category
        var releaseCategory:[DeviceSpec] = []
        if !announcedDate.isEmpty{releaseCategory.append(DeviceSpec(name: NSLocalizedString("Announced", comment: ""), value: announcedDate))}
        if !releaseStatus.isEmpty{releaseCategory.append(DeviceSpec(name: NSLocalizedString("Status", comment: ""), value: releaseStatus))}
        if !releaseCategory.isEmpty{categories.append(DeviceSpecCategory(name:NSLocalizedString("Release", comment: ""), DeviceSpecs:releaseCategory))}
        //Physical category
        var physicalCategory:[DeviceSpec] = []
        if !screenSize.isEmpty{physicalCategory.append(DeviceSpec(name:NSLocalizedString("Screen size", comment: ""), value:screenSize))}
        if !dimensions.isEmpty{physicalCategory.append(DeviceSpec(name:NSLocalizedString("Dimensions", comment: ""), value:dimensions))}
        if !weight.isEmpty{physicalCategory.append(DeviceSpec(name:NSLocalizedString("Weight", comment: ""), value:weight))}
        if !physicalCategory.isEmpty{categories.append(DeviceSpecCategory(name:NSLocalizedString("Physical", comment: ""), DeviceSpecs:physicalCategory))}
        //Hardware category
        var hardwareCategory:[DeviceSpec] = []
        if !gpu.isEmpty{hardwareCategory.append(DeviceSpec(name:NSLocalizedString("GPU", comment: ""), value:gpu))}
        if !chipset.isEmpty{hardwareCategory.append(DeviceSpec(name:NSLocalizedString("Chipset", comment: ""), value:chipset))}
        switch headphoneJack{
        case "true":
            hardwareCategory.append(DeviceSpec(name:NSLocalizedString("Headphone jack", comment: ""), value:NSLocalizedString("Yes", comment: "")))
        case "false":
            hardwareCategory.append(DeviceSpec(name:NSLocalizedString("Headphone jack", comment: ""), value:NSLocalizedString("No", comment: "")))
        default:
            break;
        }
        if !usb.isEmpty{hardwareCategory.append(DeviceSpec(name:NSLocalizedString("USB", comment: ""), value:usb))}
        if !simType.isEmpty{hardwareCategory.append(DeviceSpec(name: NSLocalizedString("Sim type", comment: ""), value:simType))}
        if !cardSlot.isEmpty{hardwareCategory.append(DeviceSpec(name:NSLocalizedString("Card slot", comment: ""), value:cardSlot))}
        if !hardwareCategory.isEmpty{categories.append(DeviceSpecCategory(name:NSLocalizedString("Hardware", comment: ""), DeviceSpecs:hardwareCategory))}
        //Software category
        var softwareCategory:[DeviceSpec] = []
        if !os.isEmpty{softwareCategory.append(DeviceSpec(name:NSLocalizedString("Operating system", comment: ""), value:os))}
        if !hardwareCategory.isEmpty{categories.append(DeviceSpecCategory(name:NSLocalizedString("Software", comment: ""), DeviceSpecs:softwareCategory))}
        
        return categories
    }
}

//Deep Copy
extension Device:NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Device()
        copy.name = self.name
        copy.brand = self.brand
        copy.cpu = self.cpu
        copy.screenResolution = self.screenResolution
        copy.ram = self.ram
        copy.batteryShort = self.batteryShort
        copy.rearCamera = self.rearCamera
        copy.frontCamera = self.frontCamera
        copy.screenSize = self.screenSize
        copy.dimensions = self.dimensions
        copy.weight = self.weight
        copy.announcedDate = self.announcedDate
        copy.releaseStatus = self.releaseStatus
        copy.gpu = self.gpu
        copy.chipset = self.chipset
        copy.headphoneJack = self.headphoneJack
        copy.usb = self.usb
        copy.simType = self.simType
        copy.cardSlot = self.cardSlot
        copy.os = self.os
        return copy
    }
}

extension Device{
    //Dummy data
    static func loadSampleDevices() -> [Device]{
        let dummyDevices: [Device] = [
            Device(name: "Mi A1", brand: "Xiaomi"),
            Device(name: "OnePlus 5T", brand: "OnePLus"),
            Device(name: "Peerpad", brand: "Peer"),
            Device(name: "S8", brand: "Samsung")
        ]
        return dummyDevices
    }
    
    static func sampleJsonData() -> String{
        //return "[{\"DeviceName\": \"Meizu V8\",    \"Brand\": \"Meizu\"}]"
        //return "[{\"DeviceName\": \"Meizu V8\",    \"Brand\": \"Meizu\"}]"
        //return "[]"
        //return "[{\"DeviceName\": \"LandRoverExplore\",    \"Brand\": \"Meizu\"}}]"
        return "[  {    \"DeviceName\": \"Meizu V8\",    \"Brand\": \"Meizu\",    \"technology\": \"GSM  CDMA  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Coming soon. Exp. release 2018, September 26th\",    \"dimensions\": \"148 x 73 x 8.4 mm (5.83 x 2.87 x 0.33 in)\",    \"weight\": \"145 g (5.11 oz)\",    \"sim\": \"Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.7 inches, 83.8 cm2 (~77.6% screen-to-body ratio)\",    \"resolution\": \"720 x 1440 pixels, 18:9 ratio (~282 ppi density)\",    \"display_c\": \"- Flyme UI\",    \"card_slot\": \"microSD, up to 128 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 bgn, WiFi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS\",    \"radio\": \"No\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP3WAVeAAC+FLAC playerrn  - MP4H.264 playerrn  - Document editorrn  - Photovideo editor\",    \"battery_c\": \"Non-removable Li-Ion 3200 mAh battery\",    \"colors\": \"Black, White\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, proximity, compass\",    \"cpu\": \"Quad-core 1.5 GHz Cortex-A53\",    \"internal\": \"32 GB, 3 RAM\",    \"os\": \"Android 8.0 (Oreo)\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE Cat4 15050 Mbps\",    \"network_c\": \"CDMA 800 & TD-SCDMA - China\",    \"chipset\": \"Mediatek MT6739\",    \"features\": \"Dual-LED dual-tone flash, panorama\",    \"gpu\": \"PowerVR GE8100\",    \"multitouch\": \"Yes\",    \"price\": \"About 100 EUR\",    \"single\": \"5 MP, f1.9\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  2100 - China\",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 38(2600), 39(1900), 40(2300), 41(2500) - China\"  },  {    \"DeviceName\": \"Samsung Galaxy J4+\",    \"Brand\": \"Samsung\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Coming soon. Exp. release 2018, October\",    \"dimensions\": \"161.4 x 76.9 x 7.9 mm (6.35 x 3.03 x 0.31 in)\",    \"weight\": \"178 g (6.28 oz)\",    \"sim\": \"Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"6.0 inches, 91.4 cm2 (~73.6% screen-to-body ratio)\",    \"resolution\": \"720 x 1480 pixels, 18.5:9 ratio (~274 ppi density)\",    \"card_slot\": \"No\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, Wi-Fi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS\",    \"radio\": \"Stereo FM radio, recording\",    \"usb\": \"microUSB 2.0, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- ANT+rn  - MP4H.264 playerrn  - MP3WAVeAAC+FLAC playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Non-removable Li-Ion 3300 mAh battery\",    \"colors\": \"Black, Gold, Pink\",    \"sensors\": \"Fingerprint (side-mounted), accelerometer, gyro, proximity, compass - North AmericarnAccelerometer, proximity - other markets\",    \"cpu\": \"Quad-core 1.4 GHz Cortex-A53\",    \"internal\": \"32 GB, 3 RAM or 16 GB, 2 GB RAM\",    \"os\": \"Android 8.1 (Oreo)\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE Cat4 15050 Mbps\",    \"chipset\": \"Qualcomm MSM8917 Snapdragon 425\",    \"features\": \"LED flash\",    \"gpu\": \"Adreno 308\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes (optional)\",    \"price\": \"About 190 EUR\",    \"single\": \"5 MP, f2.2\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1700(AWS)  1900  2100 \",    \"_4g_bands\": \" LTE\"  },  {    \"DeviceName\": \" Land Rover Explore\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, Jan\",    \"status\": \"Available. Released 2018, May\",    \"dimensions\": \"152 x 75.3 x 14 mm (5.98 x 2.96 x 0.55 in)\",    \"weight\": \"232 g (8.18 oz)\",    \"sim\": \"Hybrid Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.0 inches, 68.9 cm2 (~60.2% screen-to-body ratio)\",    \"resolution\": \"1080 x 1920 pixels, 16:9 ratio (~441 ppi density)\",    \"card_slot\": \"microSD, up to 256 GB (uses SIM 2 slot)\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 &#1072;bgnac, dual-band, WiFi Direct, hotspot\",    \"bluetooth\": \"4.1, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS\",    \"radio\": \"FM radio\",    \"usb\": \"2.0, Type-C 1.0 reversible connector\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- Fast battery chargingrn  - Snap-on accessoriesrn  - MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo viewerrn  - Document viewerrn  - Voice memodial\",    \"battery_c\": \"Non-removable Li-Ion 4000 mAh battery\",    \"colors\": \"Black\",    \"sensors\": \"Accelerometer, gyro, proximity, barometer, compass\",    \"cpu\": \"Deca-core (2x2.6 GHz Cortex-A72, 4x2 GHz Cortex-A53, 4x1.6 GHz Cortex-A53)\",    \"internal\": \"64 GB, 4 GB RAM\",    \"os\": \"Android 7.0 (Nougat), upgradable to Android 8.0 (Oreo)\",    \"body_c\": \"- IP68 dustwater proof (up to 1m for 30 mins)rn  - MIL-STD-810G\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE-A (2CA) Cat6 30050 Mbps\",    \"chipset\": \"Mediatek MT6797X Helio X27\",    \"features\": \"Dual-LED flash, HDR, panorama\",    \"protection\": \"Corning Gorilla Glass 5\",    \"gpu\": \"Mali-T880 MP4\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"price\": \"About 650 EUR\",    \"single\": \"8 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 7(2600), 8(900), 20(800)\"  },  {    \"DeviceName\": \"Samsung Galaxy Folder2\",    \"Brand\": \"Samsung\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2017, July\",    \"status\": \"Available. Released 2017, July\",    \"dimensions\": \"122 x 60.2 x 16.1 mm (4.80 x 2.37 x 0.63 in)\",    \"weight\": \"165 g (5.82 oz)\",    \"sim\": \"Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"TFT capacitive touchscreen, 16M colors\",    \"size\": \"3.8 inches, 41.1 cm2 (~56.0% screen-to-body ratio)\",    \"resolution\": \"480 x 800 pixels, 5:3 ratio (~246 ppi density)\",    \"card_slot\": \"microSD, up to 256 GB (dedicated slot)\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, WiFi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS\",    \"radio\": \"No\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4WMVH.264 playerrn  - MP3WAVeAAC+FLAC playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Removable Li-Ion 1950 mAh battery\",    \"colors\": \"Wine Red, Black, Gold\",    \"sensors\": \"Accelerometer, proximity\",    \"cpu\": \"Quad-core 1.4 GHz Cortex-A53\",    \"internal\": \"16 GB, 2 GB RAM\",    \"os\": \"Android 6.0 (Marshmallow)\",    \"speed\": \"HSPA, LTE\",    \"chipset\": \"Qualcomm MSM8917 Snapdragon 425\",    \"gpu\": \"Adreno 308\",    \"multitouch\": \"Yes\",    \"price\": \"About 200 EUR\",    \"single\": \"5 MP, f1.9\",    \"_2g_bands\": \"GSM 900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 38(2600), 39(1900), 40(2300), 41(2500)\"  },  {    \"DeviceName\": \"Wiko View Max\",    \"Brand\": \"Wiko\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, March\",    \"status\": \"Available. Released 2018, March\",    \"dimensions\": \"157.8 x 75.8 x 7.9 mm (6.21 x 2.98 x 0.31 in)\",    \"weight\": \"158 g (5.57 oz)\",    \"sim\": \"Hybrid Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.99 inches, 92.6 cm2 (~77.4% screen-to-body ratio)\",    \"resolution\": \"720 x 1440 pixels, 18:9 ratio (~269 ppi density)\",    \"card_slot\": \"microSD, up to 128 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 bgn, Wi-Fi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, IM, Push Email\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3eAAC+WAV playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Non-removable Li-Po 4000 mAh battery\",    \"colors\": \"Anthracite, Gold, Black\",    \"sar_eu\": \"0.32 Wkg (head) &nbsp; &nbsp; 1.25 Wkg (body) &nbsp; &nbsp; \",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass\",    \"cpu\": \"Quad-core 1.3 GHz Cortex-A53\",    \"internal\": \"32 GB, 3 RAM\",    \"os\": \"Android 8.1 (Oreo)\",    \"video\": \"1080p@30fps\",    \"speed\": \"HSPA 42.211.5 Mbps, LTE Cat4 15050 Mbps\",    \"chipset\": \"Mediatek MT6739WA\",    \"features\": \"HDR\",    \"gpu\": \"PowerVR GE8100\",    \"multitouch\": \"Yes\",    \"single\": \"8 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 7(2600), 20(800)\"  },  {    \"DeviceName\": \"Wiko View2 Go\",    \"Brand\": \"Wiko\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Available. Released 2018, September\",    \"dimensions\": \"153.6 x 73.1 x 8.5 mm (6.05 x 2.88 x 0.33 in)\",    \"weight\": \"160 g (5.64 oz)\",    \"sim\": \"Hybrid Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.93 inches, 88.1 cm2 (~78.4% screen-to-body ratio)\",    \"resolution\": \"720 x 1512 pixels, 19:9 ratio (~282 ppi density)\",    \"card_slot\": \"microSD, up to 128 GB (uses SIM 2 slot)\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 bgn, Wi-Fi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, IM, Push Email\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3eAAC+WAV playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Non-removable Li-Po 4000 mAh battery\",    \"colors\": \"Anthracite, Gold, Cherry Red, Deep Bleen, Supernova\",    \"sar_eu\": \"0.29 Wkg (head) &nbsp; &nbsp; 1.50 Wkg (body) &nbsp; &nbsp; \",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass\",    \"cpu\": \"Octa-core 1.4 GHz Cortex-A53\",    \"internal\": \"32 GB, 3 RAM\",    \"os\": \"Android 8.1 (Oreo)\",    \"speed\": \"HSPA 42.211.5 Mbps, LTE Cat4 15050 Mbps\",    \"chipset\": \"Qualcomm MSM8937 Snapdragon 430\",    \"features\": \"HDR\",    \"gpu\": \"Adreno 505\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes (optional)\",    \"single\": \"5 MP, f2.0\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 7(2600), 20(800)\"  },  {    \"DeviceName\": \"BLU Advance L4\",    \"Brand\": \"BLU\",    \"technology\": \"GSM  HSPA\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Available. Released 2018, September\",    \"dimensions\": \"124.3 x 65.2 x 10.4 mm (4.89 x 2.57 x 0.41 in)\",    \"weight\": \"104 g (3.67 oz)\",    \"sim\": \"Dual SIM (Micro-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"4.0 inches, 45.5 cm2 (~56.2% screen-to-body ratio)\",    \"resolution\": \"480 x 800 pixels, 5:3 ratio (~233 ppi density)\",    \"card_slot\": \"microSD, up to 64 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, hotspot\",    \"bluetooth\": \"2.1\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Removable Li-Po 1300 mAh battery\",    \"stand_by\": \"Up to 400 h (2G)  Up to 450 h (3G)\",    \"talk_time\": \"Up to 18 h (2G)  Up to 13 h (3G)\",    \"colors\": \"Black, Cyan, White, Teal\",    \"sensors\": \"Accelerometer\",    \"cpu\": \"Quad-core 1.3 GHz Cortex-A7\",    \"internal\": \"8 GB, 512 MB RAM\",    \"os\": \"Android 8.1 Oreo (Go edition)\",    \"video\": \"480p\",    \"speed\": \"HSPA 21.15.76 Mbps\",    \"network_c\": \"HSDPA 900  2100 - A350B\",    \"features\": \"LED flash\",    \"gpu\": \"Mali-400\",    \"multitouch\": \"Yes\",    \"price\": \"About 50 USD\",    \"single\": \"2 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  1900 - A350A\"  },  {    \"DeviceName\": \" 11\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Cancelled\",    \"dimensions\": \"-\",    \"weight\": \"-\",    \"sim\": \"Electronic SIM card (Apple e-SIM)\",    \"type\": \"AMOLED capacitive touchscreen, 16M colors\",    \"size\": \"1.78 inches, 10.0 cm2\",    \"resolution\": \"480 x 384 pixels (~345 ppi density)\",    \"display_c\": \"- 3D Touch displayrn  - 1000 nits\",    \"card_slot\": \"No\",    \"camera_c\": \"No\",    \"alert_types\": \"Vibration; Ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn\",    \"bluetooth\": \"5.0, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS\",    \"radio\": \"No\",    \"usb\": \"No\",    \"messaging\": \"SMS(threaded view), Email, Push Email, IM\",    \"browser\": \"No\",    \"features_c\": \"- Audio playerrn  - Photo viewerrn  - Siri natural language commands and dictation (talking mode)\",    \"battery_c\": \"Non-removable Li-Ion battery\",    \"stand_by\": \"Up to 18 h (mixed usage)\",    \"colors\": \"White, Gray\",    \"sensors\": \"Accelerometer, gyro, heart rate, barometer\",    \"cpu\": \"Dual-core\",    \"internal\": \"16 GB\",    \"os\": \"watchOS 5.0\",    \"body_c\": \"- 50m waterproofrn  - ECG certified\",    \"speed\": \"HSPA, LTE\",    \"network_c\": \"LTE band 1(2100), 3(1800), 39(1900), 40(2300), 41(2500) - China\",    \"chipset\": \"Apple S4\",    \"protection\": \"Sapphire crystal glass\",    \"gpu\": \"PowerVR\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"build\": \"Ceramic caseback\",    \"_2g_bands\": \"GSM 850  900  1800  1900 \",    \"_3_5mm_jack_\": \"No\",    \"_3g_bands\": \"HSDPA 850  900  2100  800 - Europe, Australia\",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 18(800), 19(800), 20(800), 26(850) - Europe, Australia\"  },  {    \"DeviceName\": \"Apple Watch Series 4 Aluminum\",    \"Brand\": \"Apple\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Coming soon. Exp. release 2018, September 21st\",    \"dimensions\": \"44 x 38 x 10.7 mm (1.73 x 1.50 x 0.42 in)\",    \"weight\": \"36.7 g (1.31 oz)\",    \"sim\": \"Electronic SIM card (Apple e-SIM)\",    \"type\": \"LTPO AMOLED capacitive touchscreen, 16M colors\",    \"size\": \"1.78 inches, 10.0 cm2 (~60.0% screen-to-body ratio)\",    \"resolution\": \"448 x 368 pixels (~326 ppi density)\",    \"display_c\": \"- 3D Touch displayrn  - 1000 nits\",    \"card_slot\": \"No\",    \"camera_c\": \"No\",    \"alert_types\": \"Vibration; Ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn\",    \"bluetooth\": \"5.0, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, GALILEO, QZSS\",    \"radio\": \"No\",    \"usb\": \"No\",    \"messaging\": \"SMS(threaded view), Email, Push Email, IM\",    \"browser\": \"No\",    \"features_c\": \"- Audio playerrn  - Photo viewerrn  - Siri natural language commands and dictation (talking mode)\",    \"battery_c\": \"Non-removable Li-Ion battery\",    \"stand_by\": \"Up to 18 h (mixed usage)\",    \"colors\": \"Silver, Gold, Space Gray\",    \"sensors\": \"Accelerometer, gyro, heart rate (2nd gen), barometer\",    \"cpu\": \"Dual-core\",    \"internal\": \"16 GB\",    \"os\": \"watchOS 5.0\",    \"body_c\": \"- 50m waterproofrn  - ECG certified (USA only)\",    \"speed\": \"HSPA, LTE\",    \"network_c\": \"LTE band 1(2100), 3(1800), 39(1900), 40(2300), 41(2500) - China\",    \"chipset\": \"Apple S4\",    \"protection\": \"Ion-X strengthened glass\",    \"gpu\": \"PowerVR\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"build\": \"Aluminum frame; all-ceramicsapphire crystal back\",    \"price\": \"About 430 EUR\",    \"_2g_bands\": \"GSM 850  900  1800  1900 \",    \"_3_5mm_jack_\": \"No\",    \"_3g_bands\": \"HSDPA 850  900  2100  800 - Europe, Australia\",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 18(800), 19(800), 20(800), 26(850) - Europe, Australia\"  },  {    \"DeviceName\": \"Apple Watch Series 4\",    \"Brand\": \"Apple\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Coming soon. Exp. release 2018, September 21st\",    \"dimensions\": \"44 x 38 x 10.7 mm (1.73 x 1.50 x 0.42 in)\",    \"weight\": \"48 g (1.69 oz)\",    \"sim\": \"Electronic SIM card (Apple e-SIM)\",    \"type\": \"LTPO AMOLED capacitive touchscreen, 16M colors\",    \"size\": \"1.78 inches, 10.0 cm2 (~60.0% screen-to-body ratio)\",    \"resolution\": \"448 x 368 pixels (~326 ppi density)\",    \"display_c\": \"- 3D Touch displayrn  - 1000 nits\",    \"card_slot\": \"No\",    \"camera_c\": \"No\",    \"alert_types\": \"Vibration; Ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn\",    \"bluetooth\": \"5.0, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, GALILEO, QZSS\",    \"radio\": \"No\",    \"usb\": \"No\",    \"messaging\": \"SMS(threaded view), Email, Push Email, IM\",    \"browser\": \"No\",    \"features_c\": \"- Audio playerrn  - Photo viewerrn  - Siri natural language commands and dictation (talking mode)\",    \"battery_c\": \"Non-removable Li-Ion battery\",    \"stand_by\": \"Up to 18 h (mixed usage)\",    \"colors\": \"Space Black, Silver, Gold\",    \"sensors\": \"Accelerometer, gyro, heart rate (2nd gen), barometer\",    \"cpu\": \"Dual-core\",    \"internal\": \"16 GB\",    \"os\": \"watchOS 5.0\",    \"body_c\": \"- 50m waterproofrn  - ECG certified (USA only)\",    \"speed\": \"HSPA, LTE\",    \"network_c\": \"LTE band 1(2100), 3(1800), 39(1900), 40(2300), 41(2500) - China\",    \"chipset\": \"Apple S4\",    \"protection\": \"Sapphire crystal glass\",    \"gpu\": \"PowerVR\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"build\": \"Stainless Steel frame; all-ceramicsapphire crystal back\",    \"price\": \"About 700 EUR\",    \"_2g_bands\": \"GSM 850  900  1800  1900 \",    \"_3_5mm_jack_\": \"No\",    \"_3g_bands\": \"HSDPA 850  900  2100  800 - Europe, Australia\",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 18(800), 19(800), 20(800), 26(850) - Europe, Australia\"  },  {    \"DeviceName\": \"Apple iPhone XR\",    \"Brand\": \"Apple\",    \"technology\": \"GSM  CDMA  HSPA  EVDO  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, September\",    \"status\": \"Coming soon. Exp. release 2018, October 26th\",    \"dimensions\": \"150.9 x 75.7 x 8.3 mm (5.94 x 2.98 x 0.33 in)\",    \"weight\": \"194 g (6.84 oz)\",    \"sim\": \"Nano-SIM and e-SIM\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"6.1 inches, 90.3 cm2 (~79.0% screen-to-body ratio)\",    \"resolution\": \"828 x 1792 pixels, 19.5:9 ratio (~326 ppi density)\",    \"display_c\": \"- True-tone displayrn  - Wide color gamut displayrn  - 120 Hz touch-sensing\",    \"card_slot\": \"No\",    \"alert_types\": \"Vibration, proprietary ringtones\",    \"loudspeaker_\": \"Yes, with stereo speakers\",    \"sound_c\": \"- Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 abgnac, dual-band, hotspot\",    \"bluetooth\": \"5.0, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, GALILEO, QZSS\",    \"radio\": \"No\",    \"usb\": \"2.0, proprietary reversible connector\",    \"messaging\": \"iMessage, SMS(threaded view), MMS, Email, Push Email\",    \"browser\": \"HTML5 (Safari)\",    \"features_c\": \"- Fast battery charging: 50% in 30 minrn  - Qi wireless chargingrn  - Siri natural language commands and dictationrn  - iCloud cloud servicern  - MP3WAVAAX+AIFFApple Lossless playerrn  - MP4H.265 playerrn  - Audiovideophoto editorrn  - Document editor\",    \"battery_c\": \"Non-removable Li-Ion 2942 mAh battery\",    \"talk_time\": \"Up to 25 h (3G)\",    \"colors\": \"Black, Red, Yellow, Blue, Coral\",    \"sensors\": \"Face ID, accelerometer, gyro, proximity, compass, barometer\",    \"cpu\": \"Hexa-core (2x Vortex + 4x Tempest)\",    \"internal\": \"64128256 GB, 3 GB RAM\",    \"os\": \"iOS 12\",    \"body_c\": \"- IP67 dustwater resistant (up to 1m for 30 mins)rn  - Apple Pay (Visa, MasterCard, AMEX certified)\",    \"video\": \"1080p@60fps\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE-A\",    \"network_c\": \"CDMA2000 1xEV-DO \",    \"chipset\": \"Apple A12 Bionic\",    \"features\": \"HDR\",    \"music_play\": \"Up to 65 h\",    \"protection\": \"Scratch-resistant glass, oleophobic coating\",    \"gpu\": \"Apple GPU (4-core graphics)\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"build\": \"Frontrear glass, aluminum frame (7000 series)\",    \"price\": \"About 850 EUR\",    \"single\": \"7 MP, f2.2, 32mm\",    \"_2g_bands\": \"GSM 850  900  1800  1900 \",    \"_3_5mm_jack_\": \"No\",    \"_3g_bands\": \"HSDPA 850  900  1700(AWS)  1900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 2(1900), 3(1800), 4(17002100), 5(850), 7(2600), 8(900), 12(700), 13(700), 14(700), 17(700), 18(800), 19(800), 20(800), 25(1900), 26(850), 29(700), 30(2300), 32(1500), 34(2000), 38(2600), 39(1900), 40(2300), 41(2500), 66(17002100), 71(600)\"  },  {    \"DeviceName\": \"LG Candy\",    \"Brand\": \"LG\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, September\",    \"dimensions\": \"146.3 x 73.2 x 8.2 mm (5.76 x 2.88 x 0.32 in)\",    \"weight\": \"152 g (5.36 oz)\",    \"sim\": \"Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.0 inches, 68.9 cm2 (~64.4% screen-to-body ratio)\",    \"resolution\": \"720 x 1280 pixels, 16:9 ratio (~294 ppi density)\",    \"card_slot\": \"microSD, up to 512 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, Wi-Fi Direct, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"2.0, Type-C 1.0 reversible connector\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Removable Li-Ion 2500 mAh battery\",    \"colors\": \"Black, Gold, Blue, Silver\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, proximity\",    \"cpu\": \"Quad-core 1.3 GHz Cortex-A53\",    \"internal\": \"16 GB, 2 GB RAM\",    \"os\": \"Android 7.1.2 (Nougat)\",    \"speed\": \"HSPA, LTE\",    \"features\": \"LED flash, HDR\",    \"multitouch\": \"Yes\",    \"build\": \"Plastic body\",    \"price\": \"About 6700 INR\",    \"single\": \"5 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 40(2300), 41(2500)\"  },  {    \"DeviceName\": \"YU Ace\",    \"Brand\": \"YU\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, September\",    \"dimensions\": \"148 x 70.5 x 9.6 mm (5.83 x 2.78 x 0.38 in)\",    \"weight\": \"-\",    \"sim\": \"Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.45 inches, 76.7 cm2 (~73.5% screen-to-body ratio)\",    \"resolution\": \"720 x 1440 pixels, 18:9 ratio (~295 ppi density)\",    \"card_slot\": \"microSD, up to 128 GB (dedicated slot)\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, WiFi Direct, hotspot\",    \"bluetooth\": \"4.1, A2DP\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- Fast battery chargingrn  - MP4H.264 playerrn  - MP3eAAC+WAVFlac playerrn  - Document viewerrn  - Photovideo editor\",    \"battery_c\": \"Non-removable Li-Po 4000 mAh battery\",    \"colors\": \"Charcoal Grey, Elektric Blue, Rose Gold\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, proximity\",    \"cpu\": \"Quad-core 1.5 GHz Cortex-A53\",    \"internal\": \"32 GB, 3 RAM or 16 GB, 2 GB RAM\",    \"os\": \"Android 8.0 (Oreo)\",    \"video\": \"720p@30fps\",    \"speed\": \"HSPA 21.15.76 Mbps, LTE Cat4 15050 Mbps\",    \"chipset\": \"Mediatek MT6739WW\",    \"features\": \"LED flash\",    \"gpu\": \"PowerVR GE8100\",    \"multitouch\": \"Yes\",    \"price\": \"About 6000 INR\",    \"single\": \"5 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 40(2300), 41(2500)\"  },  {    \"DeviceName\": \"LG G7 Fit\",    \"Brand\": \"LG\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Coming soon. Exp. release 2018, October\",    \"dimensions\": \"153.2 x 71.9 x 7.9 mm (6.03 x 2.83 x 0.31 in)\",    \"weight\": \"156 g (5.50 oz)\",    \"sim\": \"Single SIM (Nano-SIM) or Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"6.1 inches, 91.3 cm2 (~82.9% screen-to-body ratio)\",    \"resolution\": \"1440 x 3120 pixels, 19.5:9 ratio (~563 ppi density)\",    \"display_c\": \"- Dolby VisionHDR10 compliantrn  - Always-on display\",    \"card_slot\": \"microSD, up to 512 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- 32-bit192kHz audiorn  - DTS: X Surround Soundrn  - Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 abgnac, dual-band, Wi-Fi Direct, DLNA, hotspot\",    \"bluetooth\": \"4.2, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS\",    \"radio\": \"FM radio\",    \"usb\": \"3.1, Type-C 1.0 reversible connector, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- Fast battery charging (Quick Charge 3.0)rn  - MP4DviXXviDH.265 playerrn  - MP3WAVFLACeAAC+ playerrn  - Photovideo editorrn  - Document editor\",    \"battery_c\": \"Non-removable Li-Po 3000 mAh battery\",    \"colors\": \"New Aurora Black, New Platinum Gray\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass\",    \"internal\": \"3264 GB, 4 GB RAM\",    \"os\": \"Android 8.1 (Oreo)\",    \"body_c\": \"- IP68 dustwater proof (up to 1.5m for 30 mins)rn  - MIL-STD-810G compliant\",    \"video\": \"1080p@30fps\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE-A\",    \"chipset\": \"Qualcomm Snapdragon 821\",    \"features\": \"LED flash, HDR, panorama\",    \"protection\": \"To be confirmed\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"single\": \"8 MP, f1.9, 26mm\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2 (dual-SIM model only)\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \" LTE\"  },  {    \"DeviceName\": \"LG G7 One\",    \"Brand\": \"LG\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Coming soon. Exp. release 2018, October\",    \"dimensions\": \"153.2 x 71.9 x 7.9 mm (6.03 x 2.83 x 0.31 in)\",    \"weight\": \"156 g (5.50 oz)\",    \"sim\": \"Single SIM (Nano-SIM) or Dual SIM (Nano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"6.1 inches, 91.3 cm2 (~82.9% screen-to-body ratio)\",    \"resolution\": \"1440 x 3120 pixels, 19.5:9 ratio (~563 ppi density)\",    \"display_c\": \"- Dolby VisionHDR10 compliantrn  - Always-on display\",    \"card_slot\": \"microSD, up to 512 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- 32-bit192kHz audiorn  - DTS: X Surround Soundrn  - Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 abgnac, dual-band, Wi-Fi Direct, DLNA, hotspot\",    \"bluetooth\": \"5.0, A2DP, LE, aptX HD\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS\",    \"radio\": \"FM radio\",    \"usb\": \"3.1, Type-C 1.0 reversible connector, USB On-The-Go\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- WPC&PMA wireless charging (US version only)rn  - Fast battery charging (Quick Charge 3.0)rn  - MP4DviXXviDH.265 playerrn  - MP3WAVFLACeAAC+ playerrn  - Photovideo editorrn  - Document editor\",    \"battery_c\": \"Non-removable Li-Po 3000 mAh battery\",    \"colors\": \"New Aurora Black, New Moroccan Blue\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass, barometer\",    \"cpu\": \"Octa-core (4x2.35 GHz Kryo & 4x1.9 GHz Kryo)\",    \"internal\": \"32 GB, 4 GB RAM\",    \"os\": \"Android 8.1 (Oreo); Android One\",    \"body_c\": \"- IP68 dustwater proof (up to 1.5m for 30 mins)rn  - MIL-STD-810G compliant\",    \"video\": \"1080p@30fps\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE-A\",    \"chipset\": \"Qualcomm MSM8998 Snapdragon 835\",    \"features\": \"LED flash, HDR, panorama\",    \"protection\": \"To be confirmed\",    \"gpu\": \"Adreno 540\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"single\": \"8 MP, f1.9, 26mm\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2 (dual-SIM model only)\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1900  2100 \",    \"_4g_bands\": \" LTE\"  },  {    \"DeviceName\": \"Lava Z60s\",    \"Brand\": \"Lava\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, August\",    \"dimensions\": \"144.3 x 71.4 x 8.5 mm (5.68 x 2.81 x 0.33 in)\",    \"weight\": \"136 g (4.80 oz)\",    \"sim\": \"Dual SIM (Micro-SIMNano-SIM, dual stand-by)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.0 inches, 68.9 cm2 (~66.9% screen-to-body ratio)\",    \"resolution\": \"720 x 1280 pixels, 16:9 ratio (~294 ppi density)\",    \"card_slot\": \"microSD, up to 64 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, WiFi Direct, hotspot\",    \"bluetooth\": \"4.0, A2DP\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, IM\",    \"browser\": \"HTML\",    \"features_c\": \"- MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Non-removable Li-Po 2500 mAh battery\",    \"colors\": \"Gold, Black\",    \"sensors\": \"Accelerometer, proximity\",    \"cpu\": \"Quad-core 1.5 GHz Cortex-A53\",    \"internal\": \"16 GB, 1 GB RAM\",    \"os\": \"Android 8.1 Oreo (Go edition)\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE Cat4 15050 Mbps\",    \"chipset\": \"Mediatek MT6739WW\",    \"features\": \"LED flash\",    \"gpu\": \"PowerVR GE8100\",    \"multitouch\": \"Yes, up to 5 fingers\",    \"price\": \"About 4950 INR\",    \"single\": \"5 MP, f2.4\",    \"_2g_bands\": \"GSM 900  1800 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 900  2100 \",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 8(900), 40(2300), 41(2500)\"  },  {    \"DeviceName\": \"BLU C5\",    \"Brand\": \"BLU\",    \"technology\": \"GSM  HSPA\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, August\",    \"dimensions\": \"144.3 x 72.5 x 10.3 mm (5.68 x 2.85 x 0.41 in)\",    \"weight\": \"145 g (5.11 oz)\",    \"sim\": \"Dual SIM (Micro-SIM)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"5.0 inches, 68.9 cm2 (~65.9% screen-to-body ratio)\",    \"resolution\": \"480 x 854 pixels, 16:9 ratio (~196 ppi density)\",    \"card_slot\": \"microSD, up to 64 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, hotspot\",    \"bluetooth\": \"2.1\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Li-Po 2000 mAh battery\",    \"stand_by\": \"Up to 550 h (2G)  Up to 500 h (3G)\",    \"talk_time\": \"Up to 20 h (2G)  Up to 15 h (3G)\",    \"colors\": \"Black, Gold, Blue\",    \"sensors\": \"Accelerometer, proximity\",    \"cpu\": \"Quad-core 1.3 GHz Cortex-A7\",    \"internal\": \"8 GB, 1 GB RAM\",    \"os\": \"Android 8.1 Oreo (Go edition)\",    \"speed\": \"HSPA 21.15.76 Mbps\",    \"network_c\": \"HSDPA 850  1900  2100 \",    \"features\": \"LED flash\",    \"gpu\": \"Mali-400\",    \"multitouch\": \"Yes\",    \"price\": \"About 60 USD\",    \"single\": \"5 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  1700(AWS)  1900 \"  },  {    \"DeviceName\": \"BLU C4\",    \"Brand\": \"BLU\",    \"technology\": \"GSM  HSPA\",    \"gprs\": \"Yes\",    \"edge\": \"Yes\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, August\",    \"dimensions\": \"124.3 x 64.2 x 10.9 mm (4.89 x 2.53 x 0.43 in)\",    \"weight\": \"118 g (4.16 oz)\",    \"sim\": \"Dual SIM (Micro-SIM)\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"4.0 inches, 45.5 cm2 (~57.1% screen-to-body ratio)\",    \"resolution\": \"480 x 800 pixels, 5:3 ratio (~233 ppi density)\",    \"card_slot\": \"microSD, up to 64 GB\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"wlan\": \"Wi-Fi 802.11 bgn, hotspot\",    \"bluetooth\": \"2.1\",    \"gps\": \"Yes, with A-GPS\",    \"radio\": \"FM radio\",    \"usb\": \"microUSB 2.0\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- MP4H.264 playerrn  - MP3WAVeAAC+ playerrn  - Photovideo editorrn  - Document viewer\",    \"battery_c\": \"Li-Po 1300 mAh battery\",    \"stand_by\": \"Up to 400 h (2G)  Up to 450 h (3G)\",    \"talk_time\": \"Up to 18 h (2G)  Up to 13 h (3G)\",    \"colors\": \"Black, Gold, Blue\",    \"sensors\": \"Accelerometer\",    \"cpu\": \"Quad-core 1.3 GHz\",    \"internal\": \"8 GB, 512 MB RAM\",    \"os\": \"Android 8.1 Oreo (Go edition)\",    \"speed\": \"HSPA 21.15.76 Mbps\",    \"network_c\": \"HSDPA 850  2100 \",    \"features\": \"LED flash\",    \"gpu\": \"Mali-400\",    \"multitouch\": \"Yes\",    \"price\": \"About 50 USD\",    \"single\": \"5 MP\",    \"_2g_bands\": \"GSM 850  900  1800  1900 - SIM 1 & SIM 2\",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  1900 \"  },  {    \"DeviceName\": \"LG V40 ThinQ\",    \"Brand\": \"LG\",    \"technology\": \"GSM  HSPA  LTE\",    \"gprs\": \"Class 33\",    \"edge\": \"Class 33\",    \"announced\": \"Exp. announcement 2018, September\",    \"status\": \"Rumored\",    \"dimensions\": \"-\",    \"weight\": \"-\",    \"sim\": \"Nano-SIM\",    \"type\": \"P-OLED capacitive touchscreen, 16M colors\",    \"size\": \"6.5 inches, 109.0 cm2\",    \"resolution\": \"1440 x 3120 pixels, 18:9 ratio (~495 ppi density)\",    \"display_c\": \"- Dolby VisionHDR10 compliantrn  - Always-on displayrn  - LG UX 7.0+\",    \"card_slot\": \"microSD, up to 512 GB (dedicated slot)\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes\",    \"sound_c\": \"- 32-bit192kHz audiorn  - B&O Play certifiedrn  - 24-bit48kHz audio recordingrn  - Active noise cancellation with dedicated micrn  - DTS: X Surround Sound\",    \"wlan\": \"Wi-Fi 802.11 abgnac, dual-band, Wi-Fi Direct, DLNA, hotspot\",    \"bluetooth\": \"5.0, A2DP, LE, aptX HD\",    \"gps\": \"Yes, with A-GPS, GLONASS, GALILEO\",    \"radio\": \"Stereo FM radio with RDS\",    \"usb\": \"3.1, Type-C 1.0 reversible connector\",    \"messaging\": \"SMS(threaded view), MMS, Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- Fast battery charging: 50% in 36 min (Quick Charge 3.0)rn  - Wireless chargingrn  - MP4DviXXviDH.265WMV playerrn  - MP3WAVFLACeAAC+WMA playerrn  - Photovideo editorrn  - Document editor\",    \"battery_c\": \"Non-removable Li-Po 3300 mAh battery\",    \"colors\": \"New Aurora Black, New Platinum Gray\",    \"sensors\": \"Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass, barometer, color spectrum\",    \"cpu\": \"Octa-core (4x2.7 GHz Kryo 385 Gold & 4x1.7 GHz Kryo 385 Silver)\",    \"internal\": \"256 GB, 8 GB RAM or 128 GB, 6 GB RAM\",    \"os\": \"Android 8.1 (Oreo)\",    \"body_c\": \"- IP68 dustwater proof (up to 1.5m for 30 mins)rn  - MIL-STD-810G compliant\",    \"speed\": \"HSPA 42.25.76 Mbps, LTE-A (4CA) Cat16 1024150 Mbps\",    \"chipset\": \"Qualcomm SDM845 Snapdragon 845\",    \"features\": \"LED flash, HDR, panorama\",    \"protection\": \"Corning Gorilla Glass 5\",    \"gpu\": \"Adreno 630\",    \"multitouch\": \"Yes\",    \"nfc\": \"Yes\",    \"build\": \"Frontback glass (Gorilla Glass 5), aluminum frame\",    \"price\": \"About 800 EUR\",    \"single\": \"8 MP, f1.9\",    \"triple\": \"16 MP, f1.6, 1Âµm, 3-axis OIS, PDAF & laser AFrn  13 MP, f1.9, no AFrn  8 MP, 80mm, 3x optical zoom, OIS, PDAF\",    \"_2g_bands\": \"GSM 850  900  1800  1900 \",    \"_3_5mm_jack_\": \"Yes\",    \"_3g_bands\": \"HSDPA 850  900  1700(AWS)  1800  1900  2100 \",    \"_4g_bands\": \" LTE\"  },  {    \"DeviceName\": \"Xiaomi Mi Pad 4 Plus\",    \"Brand\": \"Xiaomi\",    \"technology\": \"LTE\",    \"gprs\": \"No\",    \"edge\": \"No\",    \"announced\": \"2018, August\",    \"status\": \"Available. Released 2018, August\",    \"dimensions\": \"245.6 x 149.1 x 8 mm (9.67 x 5.87 x 0.31 in)\",    \"weight\": \"485 g (1.07 lb)\",    \"sim\": \"Nano-SIM\",    \"type\": \"IPS LCD capacitive touchscreen, 16M colors\",    \"size\": \"10.1 inches, 295.8 cm2 (~80.8% screen-to-body ratio)\",    \"resolution\": \"1200 x 1920 pixels, 16:10 ratio (~224 ppi density)\",    \"display_c\": \"- MIUI 10\",    \"card_slot\": \"No\",    \"alert_types\": \"Vibration; MP3, WAV ringtones\",    \"loudspeaker_\": \"Yes, with stereo speakers\",    \"sound_c\": \"- Active noise cancellation with dedicated mic\",    \"wlan\": \"Wi-Fi 802.11 abgnac, dual-band, Wi-Fi Direct, hotspot\",    \"bluetooth\": \"5.0, A2DP, LE\",    \"gps\": \"Yes, with A-GPS, GLONASS, BDS (LTE model only)\",    \"radio\": \"No\",    \"usb\": \"Type-C 1.0 reversible connector\",    \"messaging\": \"Email, Push Email, IM\",    \"browser\": \"HTML5\",    \"features_c\": \"- XvidMP4H.264 playerrn  - MP3WAVeAAC+Flac playerrn  - Photovideo editorrn  - Document viewerrn  - Charging 5V2A 10W\",    \"battery_c\": \"Non-removable Li-Po 8620 mAh battery\",    \"colors\": \"Black, Rose Gold\",    \"sensors\": \"Accelerometer, gyro, proximity, compass (LTE model only)\",    \"cpu\": \"Octa-core (4x2.2 GHz Kryo 260 & 4x1.8 GHz Kryo 260)\",    \"internal\": \"128 GB, 4 GB RAM (LTE model) or 64 GB, 4 GB RAM (Wi-Fi or LTE model)\",    \"os\": \"Android 8.1 (Oreo)\",    \"speed\": \"LTE-A (3CA) Cat12 600150 Mbps\",    \"chipset\": \"Qualcomm SDM660 Snapdragon 660\",    \"features\": \"Panorama, HDR\",    \"gpu\": \"Adreno 512\",    \"multitouch\": \"Yes\",    \"build\": \"Front glass, aluminum body\",    \"price\": \"About 300 EUR\",    \"single\": \"5 MP, f2.0\",    \"_2g_bands\": \" \",    \"_3_5mm_jack_\": \"Yes\",    \"_4g_bands\": \"LTE band 1(2100), 3(1800), 5(850), 7(2600), 8(900), 34(2000), 38(2600), 39(1900), 40(2300), 41(2500)\"  }]"
    }
}

