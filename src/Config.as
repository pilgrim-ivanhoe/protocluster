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

}
}
