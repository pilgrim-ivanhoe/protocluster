/**
 * Created with IntelliJ IDEA.
 * User: korovin
 * Date: 09.03.13
 * Time: 14:02
 * To change this template use File | Settings | File Templates.
 */
package {

import flash.geom.ColorTransform;

public class ProtostarEnemy extends Protostar {
    public function ProtostarEnemy( x:Number, y:Number, dx:Number, dy:Number, radius:Number  ) {
        super( x,y,dx,dy,radius );
    }

    override public function move (environmentalResistanceCoefficient:Number, timeCorrection :Number){

        var maxRandomSpeed: Number = 50;
        if (Math.abs(xVelocityComponent) < 1) xVelocityComponent += (Math.random()*2*maxRandomSpeed) - maxRandomSpeed;
        if (Math.abs(yVelocityComponent) < 1) yVelocityComponent += (Math.random()*2*maxRandomSpeed) - maxRandomSpeed;

        super.move(environmentalResistanceCoefficient, timeCorrection );

    }

    public function runAwayFrom ( largerProtostar: Protostar):void {

        var dx:Number = largerProtostar.getCenter().x - body.x;
        var dy:Number = largerProtostar.getCenter().y - body.y;

        // определить угол
        var awayAngle:Number = Math.atan2(dy,dx);
        if( awayAngle ) {
            trace( awayAngle );
            trace( largerProtostar.getCenter().x );
            trace( largerProtostar.getCenter().y );
        }

        var xNormalizedAccelerationComponent:Number = Math.cos(awayAngle);
        var yNormalizedAccelerationComponent:Number = Math.sin(awayAngle);

        xVelocityComponent -= xNormalizedAccelerationComponent* largerProtostar.getRadius();
        yVelocityComponent -= yNormalizedAccelerationComponent* largerProtostar.getRadius();

    }


    // Перерисовать
    public function redraw( rgbColor1:Vector.<uint>,
                            rgbColor2:Vector.<uint>,
                            minRadius:Number,
                            maxRadius:Number ){

        body.graphics.clear();
        body.graphics.beginFill( 0x000000 , 1 );
        body.graphics.drawCircle( 0, 0, radius );

        var normalized:Number;
        if ( minRadius == maxRadius ) {
            normalized = 0.5;
        } else {
            normalized = ( radius - minRadius ) / ( maxRadius - minRadius );
        }

        var rgbColor:Vector.<uint> = new <uint> [
            uint(normalized * (rgbColor2[0] - rgbColor1[0] ) + rgbColor1[0]),
            uint(normalized * (rgbColor2[1] - rgbColor1[1] ) + rgbColor1[1]),
            uint(normalized * (rgbColor2[2] - rgbColor1[2] ) + rgbColor1[2])
        ];

        this.transform.colorTransform = new ColorTransform(0,0,0,1, rgbColor[0], rgbColor[1], rgbColor[2], 0);

    }
}
}
