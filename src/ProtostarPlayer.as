/**
 * Created with IntelliJ IDEA.
 * User: korovin
 * Date: 09.03.13
 * Time: 14:03
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.geom.ColorTransform;

public class ProtostarPlayer extends Protostar {
    public function ProtostarPlayer( x:Number, y:Number, dx:Number, dy:Number, radius:Number  ) {
        super( x,y,dx,dy,radius );
    }

    public function rotateToPointer ( pointerX:Number,  pointerY:Number){

        var dx:Number = pointerX - body.x;
        var dy:Number = pointerY - body.y;

        // определить угол
        var cursorAngle:Number = Math.atan2(dy,dx);

        var xNormalizedAccelerationComponent:Number = Math.cos(cursorAngle);
        var yNormalizedAccelerationComponent:Number = Math.sin(cursorAngle);

        var correction:Number = 500/radius;

        xVelocityComponent += xNormalizedAccelerationComponent*correction;
        yVelocityComponent += yNormalizedAccelerationComponent*correction;

    }
    // Перерисовать
    public function redraw( rgbColor:Vector.<uint> ){

        body.graphics.clear();
        body.graphics.beginFill( 0x000000 , 1 );
        body.graphics.drawCircle( 0, 0, radius );

        this.transform.colorTransform = new ColorTransform(0,0,0,1, rgbColor[0], rgbColor[1], rgbColor[2], 0);
    }
}
}
