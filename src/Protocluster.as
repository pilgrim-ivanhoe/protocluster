package {

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;

// Задание размера поля
//[SWF(width="800", height="600", frameRate="48", backgroundColor="#FFFFFF")]

public class Protocluster extends Sprite {

    var currentGalaxy: Protogalaxy
    public var startTime:Number;
    public var framesNumber:Number = 0;
    public var fps:TextField = new TextField();
    private var config:Config;
    public function Protocluster() {

        var controlPanel:Sprite = new Sprite();
        controlPanel.graphics.beginFill( 0xFF00FF, 1);
        controlPanel.graphics.drawRect(0, 0, 100, stage.stageHeight);
        controlPanel.x = 0;
        controlPanel.y = 0;

        var restartText:TextField = new TextField();
        restartText.text = "Restart";

        var format:TextFormat = new TextFormat();
        format.color = 0x000000;
        format.font = "Myriad Pro";
        format.size = 16;
        restartText.setTextFormat( format );

        restartText.x = 20;
        restartText.y = 100;
        controlPanel.addEventListener(MouseEvent.MOUSE_DOWN, restart);

        controlPanel.addChild(restartText);
        addChild(controlPanel);

        fpsCounter();

//        var jsonURL:URLRequest = new URLRequest("config.json");
//        var jsonLoader:URLLoader = new URLLoader(jsonURL);
//        jsonLoader.addEventListener(Event.COMPLETE, configFileLoaded);
        startWithoutConfig ();
    }

    private function startWithoutConfig(){

        config = new Config( "{\"user\":{\"color\":[100,100,100]},\"enemy\":{\"color1\":[0,0,255],\"color2\":[255,0,0],\"count\":100},\"background\":[0,0,0]}" );

        start ();
    }

    private function configFileLoaded(e:Event){

        config = new Config( String(e.target.data) );

        start ();
    }

    private function start (){

        currentGalaxy = new Protogalaxy( stage.stageWidth - 100, stage.stageHeight, config);

        currentGalaxy.x = 100;
        addChild(currentGalaxy);
        currentGalaxy.startProtogalaxy();

    }
    private function restart (e:MouseEvent):void {
        currentGalaxy.stopProtogalaxy("Restarting");
        removeChild(currentGalaxy);

        start();
    }

    // Счетчик FPS
    private function fpsCounter():void
    {
        startTime = getTimer();
        addChild(fps);

        addEventListener(Event.ENTER_FRAME, checkFPS);
    }

    private function checkFPS(e:Event):void
    {
        var currentTime:Number = (getTimer() - startTime) / 1000;

        framesNumber++;

        if (currentTime > 1)
        {
            fps.text = "FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/10.0);
            startTime = getTimer();
            framesNumber = 0;
        }
    }

}
}
