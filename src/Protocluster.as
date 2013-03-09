package {

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;
import flash.text.TextField;
import flash.events.MouseEvent;

public class Protocluster extends Sprite {

    var currentGalaxy: Protogalaxy
    public var startTime:Number;
    public var framesNumber:Number = 0;
    public var fps:TextField = new TextField();

    public function Protocluster() {


        currentGalaxy = new Protogalaxy();

        addChild(currentGalaxy);

        fpsCounter();
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
