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
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.utils.getTimer;
import flash.display.*;
import flash.text.TextField;

import flash.events.Event;

public class Protogalaxy extends Sprite  {

    private var playerProtostar:ProtostarPlayer;
    private var bounds: Rectangle;
    private var config:Config;
    private var firstEnemyIndex:uint;
    private var lastTime:int;

    public function Protogalaxy( w:int, h:int, config:Config ) {

        this.config = config;

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

        firstEnemyIndex = numChildren;
        playerProtostar = new ProtostarPlayer( bounds.width / 2, bounds.height / 2, 0, 0, 0 );
        addChild(playerProtostar);

        firstEnemyIndex = numChildren;

        fillGalaxyWIthEnemies();
    }

    private function fillGalaxyWIthEnemies(){

        var enemiesSmaller:uint = Math.round(config.enemies / 2);

        var maxProtostarSquare: Number = bounds.width * bounds.height / ( 5 * (config.enemies + 1)) ;
        var minProtostarSquare: Number = bounds.width * bounds.height / ( 7 * (config.enemies + 1));

        playerProtostar.changeSquare( ( maxProtostarSquare - minProtostarSquare) / 2 + minProtostarSquare );

        for(var i:uint = 0; i < config.enemies; i++) {

            var notDone:Boolean = true;
            while ( notDone ){

                if ( i < enemiesSmaller ) {
                    var square:Number = Math.random()*( playerProtostar.getSquare() - minProtostarSquare ) + minProtostarSquare;
                } else {
                    var square:Number = Math.random()*( maxProtostarSquare - playerProtostar.getSquare() ) + playerProtostar.getSquare();
                }

                var tempX: Number = Math.random()*bounds.width;
                var tempY: Number = Math.random()*bounds.height;

                var tempDX: Number = getRandomVelocity( 0, 10 );
                var tempDY: Number = getRandomVelocity( 0, 10 );

                var a:ProtostarEnemy = new ProtostarEnemy( tempX, tempY , tempDX, tempDY, 0 );
                a.changeSquare(square);

                notDone = false;
                for (var j:int = 1; j < numChildren; j++) {
                    if ( a.intersectionValue( Protostar(getChildAt(j))) > 0 ) {
                        notDone = true;
                    }
                }
            }
            addChild(a);
        }
    }


    private function motion (e:Event):void {

        // Проверка FPS
        var timePassed:int = getTimer() - lastTime;
        lastTime += timePassed;

        // Убегать от тех кто больше
        for(var i:int = firstEnemyIndex; i < numChildren; i++ ){
                if ( playerProtostar.intersectionValue( Protostar(getChildAt(i)) ) > 0) {
                    ProtostarEnemy(getChildAt(i)).runAwayFrom( playerProtostar );
                }
        }

        // Передвижения
        for (var i:int = 1; i < numChildren; i++) {
            Protostar(getChildAt(i)).move(0.95, timePassed / 1000 );
            Protostar(getChildAt(i)).collisionEdges(bounds);
        }

        // Проверка и обработка поглащений
        for(var i:int = 1; i < numChildren; i++ ){
            for (var j:int = i+1 ; j < numChildren; j++ ) {
                var state:int = Protostar(getChildAt(i)).absorption( Protostar(getChildAt(j)) );
                if ( state > -1 ) {
                    if ( state == 1 ) {
                        removeChildAt(i);
                        if ( i == 1 ) stopProtogalaxy("Defeat!");
                        i--;
                    } else if ( state == 2 ) {
                        removeChildAt(j);
                        if ( j == 1 ) stopProtogalaxy("Defeat!");
                        j--;
                    }
                }
            }
        }

            var playerRadius:Number = playerProtostar.getRadius();

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

            playerProtostar.redraw( config.rgbColorPlayer );

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

        // Проверка победы
        if ( totalEnemySquare <= playerProtostar.getSquare())
        {
            stopProtogalaxy("Victory!");
        }
    }

    public function startProtogalaxy(){

        addEventListener(Event.ENTER_FRAME, motion);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);

        lastTime = getTimer();
    }

    public function stopProtogalaxy( text:String ){

        var victorySprite: Sprite = new Sprite();

        var victoryText:TextField = new TextField();
        victoryText.text = text;

        var format:TextFormat = new TextFormat();
        format.color = 0xFF0000;
        format.font = "Myriad Pro";
        format.size = 20;

        victoryText.setTextFormat( format );
        victorySprite.addChild(victoryText);

        victorySprite.x = bounds.width / 2 - 100;//- victoryText.getBounds(this).width / 2;
        victorySprite.y = bounds.height / 2 - 25;// - victoryText.getBounds(this).height / 2;
        parent.addChild(victorySprite);

        removeEventListener(Event.ENTER_FRAME, motion);
        removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
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

    public function getRandomVelocity( maxVelocity:Number, minVelocity:Number ) {
        if ( maxVelocity < minVelocity ) {
            return maxVelocity;
        }
        var velocity:Number = Math.random()*( maxVelocity - minVelocity ) + minVelocity;
        if (Math.random() > .5) velocity *= -1;
        return velocity;
    }
}
}
