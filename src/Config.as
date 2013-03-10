/**
 * Created with IntelliJ IDEA.
 * User: korovin
 * Date: 10.03.13
 * Time: 0:12
 * To change this template use File | Settings | File Templates.
 */
package {
public class Config {

    public var rgbColor1:Vector.<uint>;
    public var rgbColor2:Vector.<uint>;
    public var rgbColorMiddle:Vector.<uint>;
    public var rgbColorPlayer:Vector.<uint>;
    public var enemies:uint;
    public var rgbColorBackground:Vector.<uint>;

    public function Config() {

        // Default
        rgbColor1 = new <uint>[0,0,255];
        rgbColor2 = new <uint>[255,0,0];
        rgbColorPlayer = new <uint>[255,0,0];

        loadJSONConfig();

        rgbColorMiddle = new <uint>[
            Math.round( Math.abs(rgbColor1[0] - rgbColor2[0]) / 2),
            Math.round( Math.abs(rgbColor1[1] - rgbColor2[1]) / 2),
            Math.round( Math.abs(rgbColor1[2] - rgbColor2[2]) / 2)];
    }

    public function loadJSONConfig(){

//        var jsonString:String = "{\"user\":{\"color\":[10,255,10]}," +
//                "\"enemy\":{\"color1\":[0,0,255],\"color2\":[255,0,0]," +
//                "\"count\":100}}";
        var jsonString:String = "{\"user\":{\"color\":[100,100,100]}," +
                "\"enemy\":{\"color1\":[0,0,255],\"color2\":[255,0,0]," +
                "\"count\":100}," +
                "\"background\":[0,0,0]}";

//        var myObj:Object = new Object();
//        myObj.user = new Object();
//        myObj.enemy = new Object();
//        myObj.user.color = [0,255,255];
//        myObj.enemy.color1 = [255,145,0];
//        myObj.enemy.color2 = [0,255,0];
//
//        var json:String = JSON.stringify(myObj);

        var jsonConfig = JSON.parse(jsonString);

        rgbColorPlayer = Vector.<uint>(jsonConfig["user"]["color"]);
        rgbColor1 = Vector.<uint>(jsonConfig["enemy"]["color1"]);
        rgbColor2 = Vector.<uint>(jsonConfig["enemy"]["color2"]);
        enemies = uint(jsonConfig["enemy"]["count"]);
        rgbColorBackground = Vector.<uint>(jsonConfig["background"]);

        //trace("rgbColorPlayer "+ rgbColorPlayer);

        // превращаем JSON-строку в ассоциативный массив
//        var jsonObj = JSON.parse(json, function(k,v) {
//                    if ("user" in v) {
//                        var contents = v["user"];
//
//
//                        for (var i in contents) {
//                            switch(i)
//                            {
//                                case "color":
//                                    trace( contents["color"]);
//
//                                    break;
//                            }
//                        }
//                    }
//                    if ("enemy" in v){
//                        var contents = v["enemy"];
//                        for (var i in contents) {
//                            switch(i)
//                            {
//                                case "color1":
//                                    trace( contents["color1"]);
//                                    rgbColor1 = Vector.<uint>(contents["color1"]);
//
//                                    break;
//                                case "color2":
//                                    trace( contents["color2"]);
//                                    break;
//                            }
//                        }
//                    }
//                    return v;
//                } );

    }
}
}
