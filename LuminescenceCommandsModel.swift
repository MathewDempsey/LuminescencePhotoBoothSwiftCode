//
//  LuminescenceCommandsModel.swift
//
//  Created by Mathew Dempsey on 10/27/20.
//      D5 DEM
//
//  I have provided functions for returning either
//      a UInt8 or a Data object. Use whichever is
//      easier for you.
//
//  When the device receives a command, it will stay
//      in that mode until it receives a new command
//
//  The advertising name for our device will vary.
//      Since this is (initially) a small produciton run,
//      each device will be given its own advertising name
//      in order to differentiate between different devices
//      in the same area.
//
//  The service and characteristic UUIDs will be the same for
//      each device.
//
//  For any quesitons or recommended changes, please email medpsu16@gmail.com
//

import Foundation
import CoreBluetooth

struct commandStruct : Codable
{
    let command : UInt8
    let effectName : String
}

typealias commands = [commandStruct]

/***The service for controlling our device***/
let serviceUUIDString = "6475221b-de88-46ed-9cbf-565f42149168"

/***The characteristic to write to in order to control our device***/
let characteristicUUIDString = "24517CE4-2DC1-6489-39A4-672BBE4344DF"

/***Core Bluetooth UUIDs for our service and characteristic***/
let serviceUUID = CBUUID(string: serviceUUIDString)
let characteristicUUID = CBUUID(string: characteristicUUIDString)


/*
 *  This class provides the necessary functions to interact with our device
 *  Functions are provided in here to get all our Attract Mode effect names,
 *      their corresponding command numbers, and the commands for telling the
 *      device when someone is interacting with the app, taking a picture,
 *      or using the app after taking a picture.
 */
class LuminescenceCommandsModel
{
    /***attractCommands is an array of commandStruct (see above)***/
    let attractCommands : commands
    
    /***attractNames is here for convenience, and contains all our attract mode effect names***/
    var attractNames : Array<String>
    init()
    {
        let mainBundle = Bundle.main
        let attractURL = mainBundle.url(forResource: "luminescenceAttractCommands", withExtension: "plist")
        do
        {
            let data = try Data(contentsOf: attractURL!)
            let decoder = PropertyListDecoder()
            attractCommands = try decoder.decode(commands.self, from: data)
            attractNames = []
              
        }
        catch
        {
            print(error)
            attractCommands = []
            attractNames = []
        }
        for cell in attractCommands
        {
            attractNames.append(cell.effectName)
        }
    }
    
    /***Variable here for convenience, tells you how many attract mode effects there are***/
    var numberOfAttractCommands : Int  {return attractCommands.count}
    
    
    /*
     *  This function returns the attratNames array
     *  Used to get an array of all our effect names
     */
    func getAllEffectNames() -> Array<String>
    {
        return attractNames
    }
    
    
    /*
     *  This function returns the effect name for a position in the array
     *  This will return nil if the array position passed to it is outside the array
     */
    func getEffectNameForCell(at: Int) -> String?
    {
        if ((at >= 0) && (at < numberOfAttractCommands))
        {
            return attractCommands[at].effectName
        }
        else
        {
            return nil
        }
    }
    
    
    /*
     *  This function returns the command number for a given effect name
     *  This will return nil if the effect name passed to it is not valid
     */
    func getCommandForEffectWithName(name: String) -> UInt8?
    {
        for cell in attractCommands
        {
            if (cell.effectName == name)
            {
                return cell.command
            }
        }
        return nil
    }
    
    
    /*
     *  This function returns the command number for a position in the array
     *  This will return nil if the array position passed to it is outside the array
     */
    func getCommandForCell(at: Int) -> UInt8?
    {
        if ((at >= 0) && (at < numberOfAttractCommands))
        {
            return attractCommands[at].command
        }
        return nil
    }
    
    
    /*
     *  This function returns the command number to turn on the white LEDs to act as a flash
     *      when taking a picture
     *  White LEDs will stay on until new command is recieved
     */
    func getFlashOnCommand() -> UInt8?
    {
        return 240
    }
    
    
    /*
     *  This function returns the command number to put the LEDs into "Interact mode"
     *  For when interacting with unit BEFORE picture is taken
     */
    func getStartInteractCommand() -> UInt8?
    {
        return 208
    }
    
    
    /*
     *  This function returns the command number to put the LEDs into "data collect mode"
     *  Used when interacting with software AFTER picture is taken
     *  Will remain in this mode until new command is recieved (go to Attract mode)
     */
    func getStartDataCollectCommand() -> UInt8?
    {
        return 209
    }
   
    
    /*
     *  This function returns the command DATA for a given effect name
     *  This will return nil if the effect name passed to it is not valid
     */
    func getCommandDataForEffectWithName(name: String) -> Data?
    {
        for cell in attractCommands
        {
            if (cell.effectName == name)
            {
                var myInt = cell.command
                return Data(bytes: &myInt,count: MemoryLayout.size(ofValue: myInt))
            }
        }
        return nil
    }
    
    
    /*
     *  This function returns the command DATA for a position in the array
     *  This will return nil if the array position passed to it is outside the array
     */
    func getCommandDataForCell(at: Int) -> Data?
    {
       if ((at >= 0) && (at < numberOfAttractCommands))
       {
           var myInt = attractCommands[at].command
           return Data(bytes: &myInt,count: MemoryLayout.size(ofValue: myInt))
           
       }
       return nil
    }
    
    
    /*
     *  This function returns the command DATA to turn on the white LEDs to act as a flash
     *      when taking a picture
     *  White LEDs will stay on until new command is recieved
     */
    func getFlashOnCommandData() -> Data?
    {
        var myInt = 240 as UInt8
        return Data(bytes: &myInt,count: MemoryLayout.size(ofValue: myInt))
    }
    
    
    /*
     *  This function returns the command DATA to put the LEDs into "data collect mode"
     *  Used when interacting with software AFTER picture is taken
     *  Will remain in this mode until new command is recieved (go to Attract mode)
     */
    func getDataCollectCommandData() -> Data?
    {
        var myInt = 209 as UInt8
        return Data(bytes: &myInt,count: MemoryLayout.size(ofValue: myInt))
        
    }
    
    /*
     *  This function returns the command DATA to put the LEDs into "Interact mode"
     *  For when interacting with unit BEFORE picture is taken
     */
    func getStartInteractCommandData() -> Data?
    {
        var myInt = 208 as UInt8
        return Data(bytes: &myInt,count: MemoryLayout.size(ofValue: myInt))
    }
}
