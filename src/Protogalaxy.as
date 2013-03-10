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
import flash.geom.Point;

public class Protogalaxy extends Sprite  {

    private var playerProtostar:ProtostarPlayer;
    private var bounds: Rectangle;
    private var config:Config;
    private var firstNonPlayerIndex:uint;
    private var lastTime:int; // remember the last frame's time

    public function Protogalaxy( w:int, h:int ) {

        config = new Config();

        bounds = new Rectangle(0,0, w, h);

        var background:Shape = new Shape();
        background.graphics.beginFill( 0x000000, 1);
        background.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
        background.transform.colorTransform = new ColorTransform( 0,0,0,1,
                config.rgbColorBackground[0],
                config.rgbColorBackground[1],
                config.rgbColorBackground[2],
                0
        )
        addChild(background);



//        rgbColorMiddle = new <uint>[ Math.abs( rgbColor1[0] - rgbColor2[0]) / 2,
//            Math.abs( rgbColor1[1] - rgbColor2[1]) / 2,
//            Math.abs( rgbColor1[2] - rgbColor2[2]) / 2];

       // var body: Shape = new Shape();

       // body.graphics.beginFill(0xFF0000, 1);
       // body.graphics.drawCircle(0,0,200);
       // addChild(body);

        playerProtostar = new ProtostarPlayer( bounds.x / 2, bounds.y / 2, 0,0, 30 );
        addChild(playerProtostar);
        firstNonPlayerIndex = numChildren;
        for(var i:uint = firstNonPlayerIndex; i < config.enemies; i++) {
        //var a:Protostar = new ProtostarEnemy(i*50, i*50, 10, 0, i*1);
            var a:Protostar = new ProtostarEnemy(
                    Math.random()*bounds.width,
                    Math.random()*bounds.height,
                    getRandomSpeed(),
                    getRandomSpeed(),
                    Math.random()*40);

            addChild(a);
        }

        addEventListener(Event.ENTER_FRAME, motion);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);

        lastTime = getTimer();
    }

    private function motion (e:Event):void {

        // Проверка FPS
        var timePassed:int = getTimer() - lastTime;
        lastTime += timePassed;

        // Убегать от тех кто больше
//        for(var i:int = firstNonPlayerIndex; i < numChildren; i++ ){
//            for (var j:int = 1 ; j < numChildren; j++ ) {
//
//                if ( i >= firstNonPlayerIndex &&
//                        Point.distance( Protostar(getChildAt(i)).getCenter(),
//                                Protostar(getChildAt(1)).getCenter()) <
//                                2 * ( Protostar(getChildAt(1)).getRadius() +
//                                        Protostar(getChildAt(i)).getRadius())) {
//                    ProtostarEnemy(getChildAt(i)).runAwayFrom( Protostar(getChildAt(j)) );
//                }
//            }
//        }

        // Передвижения
        for (var i:int = 1; i < numChildren; i++) {

            Protostar(getChildAt(i)).move(0.95, timePassed / 1000 );

            Protostar(getChildAt(i)).collisionEdges(bounds);

        }

        var eventHappened: Boolean = false ; // Что-то случилось

        // Проверка и обработка поглащений
        for(var i:int = 1; i < numChildren; i++ ){
            for (var j:int = i+1 ; j < numChildren; j++ ) {
                var state:int = Protostar(getChildAt(i)).absorption( Protostar(getChildAt(j)) );
                if ( state > -1 ) {
                    if ( state == 1 ) {
                        removeChildAt(i);
                        i--;
                    } else if ( state == 2 ) {
                        removeChildAt(j);
                        j--;
                    }
                    eventHappened = true;
                }
            }
        }

        if ( eventHappened ){
            var playerRadius:Number = Protostar(getChildAt(1)).getRadius();

            var minRadius:Number = playerRadius;
            var maxRadius:Number = 0;

            for (var i:int = 1; i < numChildren; i++) {
                if( Protostar(getChildAt(i)).getRadius() < minRadius )
                    minRadius = Protostar(getChildAt(i)).getRadius();
                else if( Protostar(getChildAt(i)).getRadius() > maxRadius )
                    maxRadius = Protostar(getChildAt(i)).getRadius();
            }

            // Перекраска
            var totalEnemySquare:Number = 0;

            playerProtostar.redraw( config.rgbColorPlayer);

            for (var i:int = 2; i < numChildren; i++) {
                var protostarEnemy:ProtostarEnemy = ProtostarEnemy(getChildAt(i));
                if ( protostarEnemy.getRadius() < playerRadius )  {
                    protostarEnemy.redraw(
                            config.rgbColor1, config.rgbColorMiddle,
                            minRadius, playerRadius );
                }  else {
                    protostarEnemy.redraw(
                            config.rgbColorMiddle, config.rgbColor2,
                            playerRadius, maxRadius );
                }
                totalEnemySquare += protostarEnemy.getSquare();

            }
        }

        // Проверка победы
        if ( totalEnemySquare <= playerProtostar.getSquare())
        {
            trace("Gone!");
            removeEventListener(Event.ENTER_FRAME, motion);
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
