/**
 * Created with IntelliJ IDEA.
 * User: korovin
 * Date: 09.03.13
 * Time: 12:44
 * To change this template use File | Settings | File Templates.
 */

package {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import flash.display.*;

public class Protogalaxy extends Sprite  {

    private var playerProtostar:Protostar;
    private var area: Shape;

    private var rgbColor1:Vector.<uint>;
    private var rgbColor2:Vector.<uint>;
    private var rgbColorPlayer:Vector.<uint>;
    private var rgbColorMiddle:Vector.<uint>;

    private var lastTime:int; // remember the last frame's time

    public function Protogalaxy() {

        area = new Shape();

        area.graphics.beginFill(0xFFFF00, 1);
        area.graphics.drawRect(0,0,400,200);

        addChild(area);

        rgbColor2 = new <uint>[255,0,0];
        rgbColor1 = new <uint>[0,0,255];
        rgbColorPlayer = new <uint>[255,0,0];
        rgbColorMiddle = new <uint>[ Math.abs( rgbColor1[0] - rgbColor2[0]) / 2,
            Math.abs( rgbColor1[1] - rgbColor2[1]) / 2,
            Math.abs( rgbColor1[2] - rgbColor2[2]) / 2];

       // var body: Shape = new Shape();

       // body.graphics.beginFill(0xFF0000, 1);
       // body.graphics.drawCircle(0,0,200);
       // addChild(body);

        playerProtostar = new ProtostarPlayer(60,60,50,0, 10 );
        addChild(playerProtostar);
        var a;
        for(var i:uint = 2; i < 10; i++) {
            var a:Protostar = new ProtostarEnemy(i*50, i*50, 10, 0, i*2);
//            var a:Protostar = new Protostar(Math.random()*550,
//                    Math.random()*400, getRandomSpeed(),
//                    getRandomSpeed());

            addChild(a);
        }

        addEventListener(Event.ENTER_FRAME, motion);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);

        lastTime = getTimer();
    }

    private function motion (e:Event):void {
        var timePassed:int = getTimer() - lastTime;
        lastTime += timePassed;
        //playerProtostar.move( 0.95, timePassed / 1000 );

        for (var i:int = 1; i < numChildren; i++) {

            Protostar(getChildAt(i)).move(0.95, timePassed / 1000 );

            Protostar(getChildAt(i)).collisionEdges(new Rectangle(0,0,400,200));
        }

        var eventHappened: Boolean = false ; // Что-то случилось

        for(var i:int = 1; i < numChildren; i++ ){

            for (var j:int = i+1 ; j < numChildren; j++ ) {
                var state:int = Protostar(getChildAt(i)).collision( Protostar(getChildAt(j)) )
                if ( state ) {
                    eventHappened = true;
                    if ( state == 1 ) {
                        removeChildAt(i)
                        i--;
                    } else if ( state == 2 ) {
                        removeChildAt(j);
                        j--;
                    }
                }
            }
        }

        if (eventHappened){

            var playerRadius:Number = Protostar(getChildAt(1)).getRadius();

            var minRadius:Number = playerRadius;
            var maxRadius:Number = 0;

            for (var i:int = 1; i < numChildren; i++) {
                if( Protostar(getChildAt(i)).getRadius() < minRadius )
                    minRadius = Protostar(getChildAt(i)).getRadius();
                else if( Protostar(getChildAt(i)).getRadius() > maxRadius )
                    maxRadius = Protostar(getChildAt(i)).getRadius();
            }
            //(maxRadius - minRadius) ;
            //maxRadius -  playerRadius;

            for (var i:int = 1; i < numChildren; i++) {

                Protostar(getChildAt(i)).redraw( rgbColor1, rgbColorMiddle, rgbColor2, minRadius, playerRadius, maxRadius );
            }
        }
    }



    private function rotating (e:Event):void {

        playerProtostar.rotateToPointer( mouseX, mouseY );

    }

    private function mouseDownHandler (e:MouseEvent):void {

        addEventListener(Event.ENTER_FRAME, rotating);
        addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    private function mouseUpHandler (e:MouseEvent):void {
        removeEventListener(Event.ENTER_FRAME, rotating);
    }


    // get a speed from 70-100, positive or negative
    public function getRandomSpeed() {
        var speed:Number = Math.random()*70+30;
        if (Math.random() > .5) speed *= -1;
        return speed;
    }
}
}
