/**
 * Created with IntelliJ IDEA.
 * User: korovin
 * Date: 10.03.13
 * Time: 0:12
 * To change this template use File | Settings | File Templates.
 */
package {

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;

public class Config {

    public var rgbColor1:Vector.<uint>;
    public var rgbColor2:Vector.<uint>;
    public var rgbColorMiddle:Vector.<uint>;
    public var rgbColorPlayer:Vector.<uint>;
    public var enemies:uint;
    public var rgbColorBackground:Vector.<uint>;
    public var jsonString:String;
    public var jsonLoader:URLLoader;

    public var notReady:Boolean;

    public function Config( jsonString ) {

        var jsonConfig = JSON.parse(jsonString);

        rgbColorPlayer = Vector.<uint>(jsonConfig["user"]["color"]);
        rgbColor1 = Vector.<uint>(jsonConfig["enemy"]["color1"]);
        rgbColor2 = Vector.<uint>(jsonConfig["enemy"]["color2"]);
        enemies = uint(jsonConfig["enemy"]["count"]);
        rgbColorBackground = Vector.<uint>(jsonConfig["background"]);

        rgbColorMiddle = new <uint>[
            Math.round( Math.abs(rgbColor1[0] - rgbColor2[0]) / 2),
            Math.round( Math.abs(rgbColor1[1] - rgbColor2[1]) / 2),
            Math.round( Math.abs(rgbColor1[2] - rgbColor2[2]) / 2)];
        notReady = false;

    }

    public function jsonLoaded(event:Event) {
        jsonString = String(event.target.data);
        trace( jsonString);


    }

    public function loadJSONConfig(){

        var jsonString2:String = "{\"user\":{\"color\":[100,100,100]}," +
                "\"enemy\":{\"color1\":[0,0,255],\"color2\":[255,0,0]," +
                "\"count\":100}," +
                "\"background\":[250,250,250]}";

//        var myObj:Object = new Object();
//        myObj.user = new Object();
//        myObj.enemy = new Object();
//        myObj.user.color = [0,255,255];
//        myObj.enemy.color1 = [255,145,0];
//        myObj.enemy.color2 = [0,255,0];
//
//        var json:String = JSON.stringify(myObj);

//        var jsonConfig = JSON.parse(jsonString);
//
//        rgbColorPlayer = Vector.<uint>(jsonConfig["user"]["color"]);
//        rgbColor1 = Vector.<uint>(jsonConfig["enemy"]["color1"]);
//        rgbColor2 = Vector.<uint>(jsonConfig["enemy"]["color2"]);
//        enemies = uint(jsonConfig["enemy"]["count"]);
//        rgbColorBackground = Vector.<uint>(jsonConfig["background"]);

       // jsonString = String(jsonLoader.data);

//        var jsonConfig = JSON.parse(jsonString2);
//
//        rgbColorPlayer = Vector.<uint>(jsonConfig["user"]["color"]);
//        rgbColor1 = Vector.<uint>(jsonConfig["enemy"]["color1"]);
//        rgbColor2 = Vector.<uint>(jsonConfig["enemy"]["color2"]);
//        enemies = uint(jsonConfig["enemy"]["count"]);
//        rgbColorBackground = Vector.<uint>(jsonConfig["background"]);
//
//        rgbColorMiddle = new <uint>[
//            Math.round( Math.abs(rgbColor1[0] - rgbColor2[0]) / 2),
//            Math.round( Math.abs(rgbColor1[1] - rgbColor2[1]) / 2),
//            Math.round( Math.abs(rgbColor1[2] - rgbColor2[2]) / 2)];
//        notReady = false;

    }
}
}
